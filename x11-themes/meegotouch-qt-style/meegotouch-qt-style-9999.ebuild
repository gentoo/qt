# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2 git-2

DESCRIPTION="Meeotouch Qt style"
HOMEPAGE="http://meego.gitorious.org/meegotouch/meegotouch-qt-style"
EGIT_REPO_URI="git://gitorious.org/meegotouch/meegotouch-qt-style.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-core:4"
RDEPEND=">=x11-libs/qt-svg-4.7.0:4"
