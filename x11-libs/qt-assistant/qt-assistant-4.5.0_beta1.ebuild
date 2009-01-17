# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The assistant help module for the Qt toolkit"
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+webkit"

DEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-sql-${PV}[sqlite]
	!alpha? ( !ia64? ( !ppc? ( webkit? ( ~x11-libs/qt-webkit-${PV} ) ) ) )"
RDEPEND="${DEPEND}"

# Pixeltool isn't really assistant related, but it relies on
# the assistant libraries. doc/qch/
QT4_TARGET_DIRECTORIES="tools/assistant tools/pixeltool"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
src/3rdparty/clucene/
tools/shared/fontpanel
include/
src/
doc/
"

src_configure() {
	myconf="${myconf} -no-xkb -no-tablet -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-opengl -no-qt3support -no-svg -no-gtkstyle"
	if use webkit; then
		myconf="$myconf -assistant-webkit"
	else
		myconf="$myconf -no-webkit"
	fi

	qt4-build-edge_src_configure
}

src_install() {
	qt4-build-edge_src_install
	insinto ${QTDOCDIR}
	doins -r "${S}"/doc/qch/ || die "doins qch documentation failed"
	domenu "${FILESDIR}"/Assistant.desktop || die "domenu failed"
}
