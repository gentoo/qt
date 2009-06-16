# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

DESCRIPTION="Visual process manager - Qt version of ps/top"
HOMEPAGE="http://qps.kldp.net/"
SRC_URI="http://kldp.net/frs/download.php/5253/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64"
IUSE=""

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e '/strip/d' ${PN}.pro
}

src_configure() {
	eqmake4
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1 || die
	dodoc CHANGES || die

	newicon icon/icon.xpm ${PN}.xpm || die
	domenu ${PN}.desktop || die
}
