# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-edge git

DESCRIPTION="A cross-platform Qt4 WebKit browser"
HOMEPAGE="http://arora.googlecode.com/"
EGIT_REPO_URI="git://github.com/Arora/arora.git"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="x11-libs/qt-webkit:4"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README"

src_configure() {
	eqmake4 PREFIX="/usr"
}
