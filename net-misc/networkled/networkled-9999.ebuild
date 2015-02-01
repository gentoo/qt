# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="Qt4 network traffic monitor running on system tray"
HOMEPAGE="http://github.com/alishuja/networkled"
EGIT_REPO_URI="http://github.com/alishuja/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

DOCS=( README )
