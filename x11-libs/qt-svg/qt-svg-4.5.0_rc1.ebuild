# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The SVG module for the Qt toolkit"
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="~x11-libs/qt-gui-${PV}"
RDEPEND="${DEPEND}"

QCONFIG_ADD="svg"
QCONFIG_DEFINE="QT_SVG"
QT4_TARGET_DIRECTORIES="
src/svg
src/plugins/imageformats/svg
src/plugins/iconengines/svgiconengine"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/QtSvg/
include/Qt/
include/QtGui/
include/QtCore/
include/QtXml/
src/corelib/
src/gui/
src/plugins/
src/svg/
src/xml
src/3rdparty"

src_configure() {
	myconf="${myconf} -svg -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-v -no-fontconfig -no-glib -no-opengl -no-gtkstyle -continue"
	qt4-build-edge_src_configure
}
