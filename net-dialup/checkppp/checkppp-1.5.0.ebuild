# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_PN="CheckPPP"

DESCRIPTION="Qt4 ppp client and analyzer"
HOMEPAGE="http://qt-apps.org/content/show.php/CheckPPP?content=106892"
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-libs/qt-gui:4
	net-dialup/ppp"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

src_install(){
	newbin mythread checkppp || die "newbin failed"
	dodoc ReadMe || die "dodoc failed"
}
