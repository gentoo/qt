# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE="+glib iconv icu qt3support ssl"

DEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	ssl? ( dev-libs/openssl:0[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"
PDEPEND="
	~dev-qt/qttranslations-${PV}
	qt3support? ( ~dev-qt/qtgui-${PV}[aqua=,debug=,glib=,qt3support,${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/moc-boost-lexical-cast.patch"
)

QT4_TARGET_DIRECTORIES="
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/tools/uic
	src/corelib
	src/network
	src/xml
	src/plugins/codecs/cn
	src/plugins/codecs/jp
	src/plugins/codecs/kr
	src/plugins/codecs/tw
	tools/linguist/lconvert
	tools/linguist/lrelease
	tools/linguist/lupdate"

QCONFIG_DEFINE="QT_ZLIB"

src_prepare() {
	qt4-build-multilib_src_prepare

	# bug 172219
	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CXXFLAGS} :" \
		-e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" \
		qmake/Makefile.unix || die "sed qmake/Makefile.unix failed"

	# bug 427782
	sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
		qmake/Makefile.unix || die "sed CPPFLAGS in qmake/Makefile.unix failed"
	sed -i -e 's/setBootstrapVariable QMAKE_CFLAGS_RELEASE/QMakeVar set QMAKE_CFLAGS_RELEASE/' \
		-e 's/setBootstrapVariable QMAKE_CXXFLAGS_RELEASE/QMakeVar set QMAKE_CXXFLAGS_RELEASE/' \
		configure || die "sed configure setBootstrapVariable failed"
}

src_configure() {
	myconf+="
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl -no-openvg
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		$(qt_use glib)
		$(qt_use iconv)
		$(qt_use icu)
		$(use ssl && echo -openssl-linked || echo -no-openssl)
		$(qt_use qt3support)"

	qt4-build-multilib_src_configure
}

src_install() {
	qt4-build-multilib_src_install

	emake INSTALL_ROOT="${D}" install_{mkspecs,qmake}

	# List all the multilib libdirs
	local libdirs=
	for libdir in $(get_all_libdirs); do
		libdirs+=":${EPREFIX}/usr/${libdir}/qt4"
	done

	cat <<-EOF > "${T}"/44qt4
	LDPATH="${libdirs:1}"
	EOF
	doenvd "${T}"/44qt4

	dodir "${QT4_DATADIR#${EPREFIX}}"/mkspecs/gentoo
	mv "${D}${QT4_DATADIR}"/mkspecs/{qconfig.pri,gentoo/} || die

	# Framework hacking
	if use aqua && [[ ${CHOST#*-darwin} -ge 9 ]]; then
		# TODO: do this better
		sed -i -e '2a#include <QtCore/Gentoo/gentoo-qconfig.h>\n' \
				"${D}${QT4_LIBDIR}"/QtCore.framework/Headers/qconfig.h \
			|| die "sed for qconfig.h failed"
		dosym "${QT4_HEADERDIR#${EPREFIX}}"/Gentoo \
			"${QT4_LIBDIR#${EPREFIX}}"/QtCore.framework/Headers/Gentoo
	else
		sed -i -e '2a#include <Gentoo/gentoo-qconfig.h>\n' \
				"${D}${QT4_HEADERDIR}"/QtCore/qconfig.h \
				"${D}${QT4_HEADERDIR}"/Qt/qconfig.h \
			|| die "sed for qconfig.h failed"
	fi

	keepdir "${QT4_SYSCONFDIR#${EPREFIX}}"
}
