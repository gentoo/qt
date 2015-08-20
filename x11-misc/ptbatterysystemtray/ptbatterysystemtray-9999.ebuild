# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="A simple battery monitor in the system tray"
HOMEPAGE="https://gitorious.org/ptbatterysystemtray"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 ${PN}.pro INSTALL_PREFIX=/usr
}
