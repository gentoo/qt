# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1
}
