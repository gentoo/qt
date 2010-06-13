# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/q4wine/q4wine-0.112-r1.ebuild,v 1.2 2010/06/10 21:10:57 maekke Exp $

EAPI="2"

inherit git qt4-edge cmake-utils

DESCRIPTION="Qt4 GUI configuration tool for Wine"
HOMEPAGE="http://q4wine.brezblock.org.ua/"
EGIT_REPO_URI="git://github.com/brezerk/q4wine.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug +icoutils winetriks +wineappdb"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	dev-util/cmake"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	icoutils? ( >=media-gfx/icoutils-0.26.0 )
	sys-fs/fuseiso"

DOCS=(AUTHORS ChangeLog README)

S="${WORKDIR}/${PF}"

src_unpack() {
	git_src_unpack
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use debug)
		$(cmake-utils_use_with icoutils)
		$(cmake-utils_use_with winetriks)
		$(cmake-utils_use_with wineappdb)
	)

	cmake-utils_src_configure
}
