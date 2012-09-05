# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="A small Qt-based tool to allow you to compose fancy and stylish screenshots"
HOMEPAGE="http://code.google.com/p/screenie"
EGIT_REPO_URI="git://github.com/ariya/screenie.git"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-desktop.patch"
)

src_prepare () {
	qt4-r2_src_prepare
	sed -i -e "/^Exec/s:Screenie:${PN}:" -e "/^TryExec/s:Screenie:${PN}:" \
		"${S}"/src/Screenie/res/${PN}.desktop || die
}

src_install() {
	# The package uses generic library names that may cause collisions
	# in the future. They need to be moved to a subfolder
	dolib.so "${S}"/bin/release/*.so*
	newbin "${S}"/bin/release/Screenie ${PN}
	newicon "${S}"/src/Resources/img/application-icon.png ${PN}.png
	domenu "${S}"/src/Screenie/res/${PN}.desktop
}
