# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The ECMAScript module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="iconv private-headers"

DEPEND="~x11-libs/qt-core-${PV}[debug=,stable-branch=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="src/script/"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	include/Qt/
	include/QtCore/
	include/QtScript/
	src/corelib/"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} $(qt_use iconv) -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-opengl -no-svg -no-gtkstyle"
	qt4-build-edge_src_configure
}

src_install() {
	qt4-build-edge_src_install
	#install private headers
	if use private-headers; then
		insinto ${QTHEADERDIR}/QtScript/private
		find "${S}"/src/script -type f -name "*_p.h" -exec doins {} \;
	fi
}
