# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The Qt multimedia module"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 -sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
else
	KEYWORDS=""
fi

IUSE="iconv"

DEPEND="!aqua? ( media-libs/alsa-lib )
	~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-gui-${PV}[aqua=,c++0x=,qpa=,debug=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="src/multimedia"
	
	if [[ ${PV} != 4*9999 ]]; then
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
	fi

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} $(qt_use iconv) -no-xkb  -no-fontconfig -no-xrender
		-no-xrandr -no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm
		-no-opengl -no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff  -no-accessibility
		-no-fontconfig -no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite
		-no-sql-sqlite2 -no-sql-odbc -no-glib -no-opengl -no-svg -no-gtkstyle
		-no-phonon-backend -no-script -no-scripttools -no-cups -no-xsync
		-no-xinput"

	qt4-build-edge_src_configure
}
