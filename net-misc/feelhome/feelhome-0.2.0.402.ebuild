# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4-r2

MY_PN="FeelHome"

DESCRIPTION="A client for remote data storage service"
HOMEPAGE="http://nuxinov.com"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_install() {
	dobin ${PN} || die "installing binary failed"
	doicon ${PN}.png || die "installing icon failed"

	dodoc README || die "installing docs failed"

	sed -e "s/\(Comment=\)/\1${DESCRIPTION}/" \
		-e "s/kontrolpack/${PN}/" \
		-i "${PN}.desktop" || die "sed desktop file failed"
	insinto /usr/share/applications
	doins "${PN}.desktop" || die "installing desktop file failed"
}
