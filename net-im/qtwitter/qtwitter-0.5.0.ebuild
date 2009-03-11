# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

DESCRIPTION="A Qt client for Twitter"
HOMEPAGE="http://www.qt-apps.org/content/show.php/qTwitter?content=99087"
SRC_URI="http://cloud.github.com/downloads/ayoy/${PN}/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	qt4-edge_src_prepare
	echo "CONFIG += nostrip" >> "${S}"/${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README || die "dodoc failed"
}
