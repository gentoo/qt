# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="Qt4 Connman Applet"
HOMEPAGE="https://github.com/OSSystems/qconnman"
EGIT_REPO_URI="git://github.com/OSSystems/${PN}.git"

LICENSE="LGPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/connman
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"
