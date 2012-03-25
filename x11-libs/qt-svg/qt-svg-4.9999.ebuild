# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit qt4-build-edge

DESCRIPTION="The SVG module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWORDS=""
fi
IUSE="+accessibility iconv"

DEPEND="~x11-libs/qt-gui-${PV}[accessibility=,aqua=,c++0x=,debug=,qpa=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/svg
		src/plugins/imageformats/svg
		src/plugins/iconengines/svgiconengine"
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
			include/QtSvg/
			include/Qt/
			include/QtGui/
			include/QtCore/
			include/QtXml/
			src/corelib/
			src/gui/
			src/plugins/
			src/xml
			src/3rdparty"
	fi

	QCONFIG_ADD="svg"
	QCONFIG_DEFINE="QT_SVG"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -svg
		$(qt_use accessibility)
		$(qt_use iconv)
		-no-xkb -no-xrender
		-no-xrandr -no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm
		-no-opengl -no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff
		-no-fontconfig -no-glib -no-gtkstyle"
	qt4-build-edge_src_configure
}
