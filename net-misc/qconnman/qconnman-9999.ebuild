# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="Qt4 Connman Applet"
HOMEPAGE="https://bitbucket.org/devonit/qconnman"
EGIT_REPO_URI="https://bitbucket.org/devonit/qconnman.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/connman
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4"
	
RDEPEND="${DEPEND}"

DOCS="README AUTHORS"

src_configure() {
	
	eqmake4 ${PN}.pro PREFIX="/usr"
	
}

## TODO: add use staticlib
