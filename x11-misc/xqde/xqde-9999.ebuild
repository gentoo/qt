# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit git qt4-r2

DESCRIPTION="A docker application similar to KXDocker"
HOMEPAGE="http://sourceforge.net/projects/xqde/"
EGIT_REPO_URI="git://xqde.git.sourceforge.net/gitroot/xqde/xqde"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/qt-gui:4[dbus]"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	S=${S}/trunk
}
