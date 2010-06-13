# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_PKG_PN="GoogleImageDownloader"
MY_SRC_PN="${MY_PKG_PN/Image/Img}"
MY_PV="v${PV}"
MY_P="${MY_PKG_PN}-${MY_PV}"

DESCRIPTION="Desktop frontend to Google image search"
HOMEPAGE="http://sourceforge.net/projects/googleimagedown"
SRC_URI="mirror://sourceforge/googleimagedown/${MY_P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=x11-libs/qt-gui-4.5.2:4
	>=x11-libs/qt-webkit-4.5.2:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_SRC_PN/G/g}"

src_install() {
	dobin ${MY_SRC_PN} || die "dobin failed"
	dodoc README.txt || die "dodoc failed"
}
