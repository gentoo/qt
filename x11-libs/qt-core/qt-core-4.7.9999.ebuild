# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
SLOT="4"
KEYWORDS=""
IUSE="+glib iconv optimized-qmake private-headers qt3support ssl"

RDEPEND="sys-libs/zlib
	glib? ( dev-libs/glib )
	ssl? ( dev-libs/openssl )
	!<x11-libs/qt-4.4.0:4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
PDEPEND="qt3support? ( ~x11-libs/qt-gui-${PV}[qt3support,stable-branch=] )"

PATCHES=( "${FILESDIR}/qt-4.7-nolibx11.patch" )

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

	QT4_EXTRACT_DIRECTORIES="
		include/Qt
		include/QtCore
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
		src/3rdparty/sha1/
		src/3rdparty/easing
		src/script
		tools/linguist/shared
		translations"
	qt4-build-edge_pkg_setup
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		${QT4_EXTRACT_DIRECTORIES}"
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
	unset QMAKESPEC

	myconf="${myconf}
		$(qt_use glib)
		$(qt_use iconv)
		$(qt_use optimized-qmake)
		$(qt_use ssl openssl)
		$(qt_use qt3support)"

	myconf="${myconf} -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -no-cups -no-gif -no-libpng
		-no-libmng -no-libjpeg -system-zlib -no-webkit -no-phonon -no-xmlpatterns
		-no-freetype -no-libtiff  -no-accessibility -no-fontconfig -no-opengl
		-no-svg -no-gtkstyle -no-phonon-backend -no-script -no-scripttools
		-no-cups -no-xsync -no-xinput -no-multimedia"
	qt4-build-edge_src_configure
}

src_compile() {
	# bug 259736
	unset QMAKESPEC
	qt4-build-edge_src_compile
}

src_install() {
	dobin "${S}"/bin/{qmake,moc,rcc,uic,lconvert,lrelease,lupdate} || die

	install_directories src/{corelib,xml,network,plugins/codecs}

	emake INSTALL_ROOT="${D}" install_mkspecs || die

	#install private headers
	if use private-headers; then
		insinto ${QTHEADERDIR}/QtCore/private
		find "${S}"/src/corelib -type f -name "*_p.h" -exec doins {} \;
	fi
	# use freshly built libraries
	local DYLD_FPATH=
	[[ -d "${S}"/lib/QtCore.framework ]] \
		&& DYLD_FPATH=$(for x in "${S}/lib/"*.framework; do echo -n ":$x"; done)
	DYLD_LIBRARY_PATH="${S}/lib${DYLD_FPATH}" \
	LD_LIBRARY_PATH="${S}/lib" "${S}"/bin/lrelease translations/*.ts || die
	insinto ${QTTRANSDIR}
	doins translations/*.qm || die

	setqtenv
	fix_library_files

	# List all the multilib libdirs
	local libdirs=
	for libdir in $(get_all_libdirs); do
		libdirs="${libdirs}:/usr/${libdir}/qt4"
	done

	cat <<-EOF > "${T}/44qt4"
	LDPATH=${libdirs:1}
	EOF
	doenvd "${T}/44qt4"

	dodir /${QTDATADIR}/mkspecs/gentoo
	mv "${D}"/${QTDATADIR}/mkspecs/qconfig.pri "${D}${QTDATADIR}"/mkspecs/gentoo \
		|| die

	sed -i -e '2a#include <Gentoo/gentoo-qconfig.h>\n' \
			"${D}${QTHEADERDIR}"/QtCore/qconfig.h \
			"${D}${QTHEADERDIR}"/Qt/qconfig.h \
		|| die
	sed -i -e '46a#include <Gentoo/gentoo-qconfig.h>\n' \
			"${D}${QTHEADERDIR}"/QtCore/qglobal.h \
		|| die
	QCONFIG_DEFINE="QT_SHARED"
	if use glib; then
		QCONFIG_DEFINE+=" $(use glib && echo QT_GLIB)
			$(use ssl && echo QT_OPENSSL)"
		install_qconfigs
	fi

	# remove some unnecessary headers
	rm -f "${D}${QTHEADERDIR}"/{Qt,QtCore}/{\
qatomic_macosx.h,\
qatomic_windows.h,\
qatomic_windowsce.h,\
qt_windows.h}

	keepdir "${QTSYSCONFDIR}"
}
