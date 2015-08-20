# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2 subversion

DESCRIPTION="Small RDC client"
HOMEPAGE="http://code.google.com/p/qtdesktop/"
ESVN_REPO_URI="http://qtdesktop.googlecode.com/svn/trunk/qrdc"
ESVN_PROJECT="qrdc"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1
}
