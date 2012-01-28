# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWORDS=""
fi
IUSE="+glib iconv optimized-qmake qt3support ssl"

DEPEND="sys-libs/zlib
	glib? ( dev-libs/glib )
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"
PDEPEND="qt3support? ( ~x11-libs/qt-gui-${PV}[aqua=,c++0x=,qpa=,debug=,glib=,qt3support] )"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/tools/bootstrap
		src/tools/moc
		src/tools/rcc
		src/tools/uic
		src/corelib
		src/xml
		src/network
		src/plugins/codecs
		tools/linguist/lconvert
		tools/linguist/lrelease
		tools/linguist/lupdate"
	
	# This is not needed in live ebuilds since the git repo contains everything
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES=" ${QT4_TARGET_DIRECTORIES}
			include/Qt
			include/QtCore
			include/QtDeclarative
			include/QtGui
			include/QtNetwork
			include/QtScript
			include/QtXml
			src/plugins/plugins.pro
			src/plugins/qpluginbase.pri
			src/src.pro
			src/3rdparty/des
			src/3rdparty/harfbuzz
			src/3rdparty/md4
			src/3rdparty/md5
			src/3rdparty/sha1
			src/3rdparty/easing
			src/3rdparty/zlib_dependency.pri
			src/declarative
			src/gui
			src/script
			tools/shared
			tools/linguist/shared
			translations"
	fi
	qt4-build-edge_pkg_setup
}

src_prepare() {
	# Don't pre-strip, bug 235026
	for i in kr jp cn tw ; do
		echo "CONFIG+=nostrip" >> "${S}"/src/plugins/codecs/${i}/${i}.pro
	done

	qt4-build-edge_src_prepare

	# bug 172219
	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CXXFLAGS} :" \
		"${S}/qmake/Makefile.unix" || die "sed qmake/Makefile.unix CXXFLAGS failed"
	sed -i -e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" \
		"${S}/qmake/Makefile.unix" || die "sed qmake/Makefile.unix LDFLAGS failed"
}

src_configure() {
	myconf+="
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		$(qt_use glib)
		$(qt_use iconv)
		$(qt_use optimized-qmake)
		$(qt_use ssl openssl)
		$(qt_use qt3support)"

	qt4-build-edge_src_configure
}

src_install() {
	dobin "${S}"/bin/{qmake,moc,rcc,uic,lconvert,lrelease,lupdate} || die "dobin failed"

	install_directories src/{corelib,xml,network,plugins/codecs}

	emake INSTALL_ROOT="${D}" install_mkspecs || die "emake install_mkspecs failed"

	#install private headers
	insinto "${QTHEADERDIR#${EPREFIX}}"/QtCore/private
	find "${S}"/src/corelib -type f -name "*_p.h" -exec doins {} \;

	# use freshly built libraries
	local DYLD_FPATH=
	[[ -d "${S}"/lib/QtCore.framework ]] \
		&& DYLD_FPATH=$(for x in "${S}/lib/"*.framework; do echo -n ":$x"; done)
	DYLD_LIBRARY_PATH="${S}/lib${DYLD_FPATH}" \
	LD_LIBRARY_PATH="${S}/lib" "${S}"/bin/lrelease translations/*.ts \
		|| die "generating translations failed"
	insinto "${QTTRANSDIR#${EPREFIX}}"
	doins translations/*.qm || die "doins translations failed"

	setqtenv
	fix_library_files

	# List all the multilib libdirs
	local libdirs=
	for libdir in $(get_all_libdirs); do
		libdirs+=":${EPREFIX}/usr/${libdir}/qt4"
	done

	cat <<-EOF > "${T}/44qt4"
	LDPATH="${libdirs:1}"
	EOF
	doenvd "${T}/44qt4"

	dodir "${QTDATADIR#${EPREFIX}}"/mkspecs/gentoo || die "dodir failed"
	mv "${D}/${QTDATADIR}"/mkspecs/qconfig.pri "${D}${QTDATADIR}"/mkspecs/gentoo \
		|| die "Failed to move qconfig.pri"

	# Framework hacking
	if use aqua && [[ ${CHOST#*-darwin} -ge 9 ]] ; then
		#TODO do this better
		sed -i -e '2a#include <QtCore/Gentoo/gentoo-qconfig.h>\n' \
				"${D}${QTLIBDIR}"/QtCore.framework/Headers/qconfig.h \
			|| die "sed for qconfig.h failed."
		dosym "${QTHEADERDIR#${EPREFIX}}"/Gentoo "${QTLIBDIR#${EPREFIX}}"/QtCore.framework/Headers/Gentoo ||
			die "dosym failed"
	else
		sed -i -e '2a#include <Gentoo/gentoo-qconfig.h>\n' \
				"${D}${QTHEADERDIR}"/QtCore/qconfig.h \
				"${D}${QTHEADERDIR}"/Qt/qconfig.h \
			|| die "sed for qconfig.h failed"
	fi

	if use glib; then
		QCONFIG_DEFINE="$(use glib && echo QT_GLIB)
			$(use ssl && echo QT_OPENSSL)"
		install_qconfigs
	fi

	# remove .la files
	find "${D}${QTLIBDIR}" -name "*.la" -print0 | xargs -0 rm

	keepdir "${QTSYSCONFDIR#${EPREFIX}}"

	# Framework magic
	fix_includes
}
