# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib qt4-r2

MY_PN="QuantumStyle"

DESCRIPTION="SVG themable style for Qt4 and KDE"
HOMEPAGE="http://kde-look.org/content/show.php/?content=101088"
SRC_URI="http://saidlankri.free.fr/${MY_PN}-${PV/*_rc/RC}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

src_install() {
	insinto /usr/$(get_libdir)/qt4/plugins/styles
	doins style/libquantumstyle.so
	dodoc themeconfig/default.qsconfig style/ReadMe
	dobin themebuilder/qsthemebuilder
}
