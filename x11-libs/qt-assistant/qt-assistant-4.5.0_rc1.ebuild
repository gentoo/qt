# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The assistant help module for the Qt toolkit"
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 -sparc ~x86"
IUSE=""

DEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-sql-${PV}[sqlite]
	~x11-libs/qt-webkit-${PV}"
RDEPEND="${DEPEND}"

# Pixeltool isn't really assistant related, but it relies on
# the assistant libraries.
QT4_TARGET_DIRECTORIES="tools/assistant tools/pixeltool tools/qdoc3"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
src/3rdparty/clucene/
tools/shared/fontpanel
include/
src/
doc/"

src_configure() {
	myconf="${myconf} -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-opengl -no-qt3support -no-svg -no-gtkstyle"
	qt4-build-edge_src_configure
}

src_install() {
	qt4-build-edge_src_install
	insinto ${QTDOCDIR}
	doins -r "${S}"/doc/qch/ || die "Installing qch documentation failed"
	dobin "${S}"/bin/qhelpgenerator || die "dobin failed"
	domenu "${FILESDIR}"/Assistant.desktop
}
