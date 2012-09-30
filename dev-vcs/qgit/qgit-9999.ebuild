# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit qt4-r2 git-2

DESCRIPTION="GUI interface for git/cogito SCM"
HOMEPAGE="http://digilander.libero.it/mcostalba/"
EGIT_REPO_URI="git://repo.or.cz/${PN}4/redivivus.git
	http://repo.or.cz/r/${PN}4/redivivus.git"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}
	>=dev-vcs/git-1.5.3"

src_install() {
	newbin bin/${PN} ${PN}4
	dodoc README
}
