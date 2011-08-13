# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The testing framework module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="iconv"

DEPEND="~x11-libs/qt-core-${PV}[debug=,stable-branch=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="src/testlib"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	include/QtTest/
	include/QtCore/
	src/corelib/"
	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} $(qt_use iconv) -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-opengl -no-svg"
	qt4-build-edge_src_configure
}
