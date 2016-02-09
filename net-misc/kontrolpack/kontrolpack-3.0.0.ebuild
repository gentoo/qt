# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qmake-utils

MY_PN="KontrolPack"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Remote shell command executor and LAN manager"
HOMEPAGE="http://sourceforge.net/projects/kontrolpack/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="dev-db/sqlite:3
	dev-libs/libxml2:2
	dev-libs/openssl:0
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e "s/-lssl/-lcrypto/" libsecuretcp/libsecuretcp.pro || die
}

src_configure() {
	eqmake4
}

src_install() {
	dobin bin/${PN}
	dolib bin/*.so*

	doicon ${PN}/${PN}.png
	domenu ${PN}/${PN}.desktop
}
