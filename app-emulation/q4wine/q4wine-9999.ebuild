# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/q4wine/q4wine-0.112-r1.ebuild,v 1.2 2009/06/10 21:10:57 maekke Exp $

EAPI="2"
inherit qt4-edge cmake-utils git

DESCRIPTION="Qt4 GUI for wine"
HOMEPAGE="http://q4wine.brezblock.org.ua/"
EGIT_REPO_URI="git://github.com/brezerk/q4wine.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug icoutils winetriks embedded-fuseiso development"

DEPEND="x11-libs/qt-gui:4[debug?]
	x11-libs/qt-sql:4[debug?,sqlite]
	dev-util/cmake
	embedded-fuseiso? ( dev-libs/libzip >=sys-fs/fuse-2.7.0 )"

RDEPEND="x11-libs/qt-gui:4[debug?]
	x11-libs/qt-sql:4[debug?,sqlite]
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	icoutils? ( >=media-gfx/icoutils-0.26.0 )"

DOCS="README"

S="${WORKDIR}/${PF}"

src_configure() {
	mycmakeargs="${mycmakeargs} \
		$(cmake-utils_use_with icoutils ICOUTILS) \
		$(cmake-utils_use_with winetriks WINETRIKS) \
		$(cmake-utils_use_with embedded-fuseiso EMBEDDED_FUSEISO) \
		$(cmake-utils_use_with development DEVELOP_STUFF)"

	cmake-utils_src_configure
}
