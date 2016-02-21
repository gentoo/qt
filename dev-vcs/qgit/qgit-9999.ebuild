# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-r2 git-2

DESCRIPTION="Qt4 GUI for git repositories"
HOMEPAGE="http://libre.tibirna.org/projects/qgit/wiki/QGit"
EGIT_REPO_URI="git://repo.or.cz/qgit4/redivivus.git
	http://repo.or.cz/r/qgit4/redivivus.git"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	>=dev-vcs/git-1.6
"

src_install() {
	newbin bin/qgit qgit4
	newicon src/resources/qgit.png qgit4.png
	make_desktop_entry qgit4 QGit qgit4
	dodoc README
}
