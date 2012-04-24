# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2

MY_PN="GoogleImageDownloader"

DESCRIPTION="Desktop frontend to Google image search"
HOMEPAGE="http://sourceforge.net/projects/googleimagedown"
SRC_URI="mirror://sourceforge/googleimagedown/${MY_PN}-v${PV}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-webkit:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN/Google/}"

src_install() {
	dobin "bin/${MY_PN}"
	dodoc README.txt
}
