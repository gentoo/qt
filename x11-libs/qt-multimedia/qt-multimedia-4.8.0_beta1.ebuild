# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build

DESCRIPTION="The Qt multimedia module"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="iconv"

DEPEND="~x11-libs/qt-core-${PV}[debug=]
	~x11-libs/qt-gui-${PV}[debug=]
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="src/multimedia"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/Qt/
		include/QtCore/
		include/QtGui/
		include/QtMultimedia/
		include/QtNetwork/
		src/src.pro
		src/3rdparty/
		src/corelib/
		src/gui/
		src/network/
		src/plugins/
		src/tools/"

	qt4-build_pkg_setup
}

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
