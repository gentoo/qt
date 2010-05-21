# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="http://github.com/alishuja/networkled.git"

inherit qt4-r2 git

DESCRIPTION="Qt4 network traffic monitor running on system tray"
HOMEPAGE="http://github.com/alishuja/networkled"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

DOCS="README"
