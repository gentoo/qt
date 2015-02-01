# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils qt4-r2

MY_PN="KontrolPack"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == 9999 ]]; then
	inherit subversion
	ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Remote shell command executor and LAN manager"
HOMEPAGE="http://www.kontrolpack.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="dev-db/sqlite
	dev-libs/libxml2
	dev-libs/openssl
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtgui-4.5:4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s/-lssl/-lcrypto/" libsecuretcp/libsecuretcp.pro \
		|| die "sed failed"
}

src_install() {
	dobin bin/${PN}
	dolib bin/*.so*

	doicon ${PN}/${PN}.png
	domenu ${PN}/${PN}.desktop
}
