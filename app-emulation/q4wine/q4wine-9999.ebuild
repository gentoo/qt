# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 cmake-utils git-2

DESCRIPTION="Qt4 utility for Wine applications and prefixes management."
HOMEPAGE="http://q4wine.brezblock.org.ua/"
EGIT_REPO_URI="git://github.com/brezerk/q4wine"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug +icoutils +wineappdb +dbus gnome kde"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	dev-util/cmake"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	icoutils? ( >=media-gfx/icoutils-0.26.0 )
	sys-fs/fuseiso
	kde? ( kde-base/kdesu )
	gnome? ( x11-libs/gksu )
	dbus? ( x11-libs/qt-dbus:4 )"

DOCS=(AUTHORS ChangeLog README)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use_with icoutils)
		$(cmake-utils_use_with wineappdb)
		$(cmake-utils_use_with dbus)
	)

	cmake-utils_src_configure
}
