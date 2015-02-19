# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit qt4-r2 subversion

DESCRIPTION="A cosmic recursive flame fractal editor"
HOMEPAGE="http://code.google.com/p/qosmic/"
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-lang/lua-5.1.4
	=media-gfx/flam3-9999
	>=dev-qt/qtgui-4.6:4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="changes.txt README"

src_configure() {
	eqmake4 "CONFIG += link_pkgconfig"
}
