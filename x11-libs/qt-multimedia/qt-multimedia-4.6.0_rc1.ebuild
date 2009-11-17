# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-multimedia/qt-multimedia-4.6.0_beta1.ebuild,v 1.1 2009/10/16 16:47:56 wired Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Qt multimedia module"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[debug=]
	~x11-libs/qt-gui-${PV}[debug=]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/multimedia"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/Qt/
include/QtCore/
include/QtGui/
include/QtMultimedia/
src/src.pro
src/corelib/
src/gui/
src/plugins
src/3rdparty
src/tools"

src_configure() {
	myconf="${myconf} $(qt_use iconv) -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff  -no-accessibility -no-fontconfig
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2
		-no-sql-odbc -no-glib -no-opengl -no-svg -no-gtkstyle -no-phonon-backend -no-script
		-no-scripttools -no-cups -no-xsync -no-xinput"

	qt4-build_src_configure
}
