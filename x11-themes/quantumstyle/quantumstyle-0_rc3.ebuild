# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

MY_PN="QuantumStyle"
MY_P="${MY_PN}-${PV/*_/}"

DESCRIPTION="SVG themable style for Qt 4 and KDE"
HOMEPAGE="http://kde-look.org/content/show.php/QuantumStyle?content=101088"
SRC_URI="http://kde-look.org/CONTENT/content-files/101088-${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

DEPEND="
	x11-libs/qt-gui:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_configure() {
	eqmake4 ${PN}.pro || die "qmake failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	insinto /usr/lib/qt4/plugins/styles
	doins style/libquantumstyle.so || die "libquantumstyle.so install failed"

	dodoc themeconfig/default.qsconfig || die "sample config install failed"
	dodoc style/ReadMe || die "readme install failed"

	dobin themebuilder/qsthemebuilder || die "bin install failed"
}
