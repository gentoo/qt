# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_PN="KontrolPack"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Qt-based cross-platform remote shell command executor and LAN manager"
HOMEPAGE="http://www.kontrolpack.com"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="x11-libs/qt-gui:4"
DEPEND="app-arch/zip
	${RDEPEND}"

S="${WORKDIR}/${MY_P}-src"

src_prepare() {
	mv icons/cmd2.PNG icons/cmd2.png
}

src_install() {
	dobin ${MY_PN/P/p} || die "dobin failed"
}
