# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/q4wine/q4wine-1.1_p2-r1.ebuild,v 1.1 2013/12/28 00:07:53 pesa Exp $

EAPI=5

PLOCALES="af cs de en es fa he it ru uk pl pt"

inherit cmake-utils git-r3 l10n

DESCRIPTION="Qt4 GUI configuration tool for Wine"
HOMEPAGE="http://q4wine.brezblock.org.ua/"
EGIT_REPO_URI="https://github.com/brezerk/q4wine.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+dbus debug +icoutils +wineappdb"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication
	dev-qt/qtsql:4[sqlite]
	dbus? ( dev-qt/qtdbus:4 )
"
RDEPEND="${DEPEND}
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	sys-fs/fuseiso
	icoutils? ( >=media-gfx/icoutils-0.26.0 )
"

DOCS=(AUTHORS ChangeLog README)

remove_from_LINGUAS() {
	sed -i -e "/SET\s*(\s*LINGUAS / s: ${1}_\w\w::" \
		src/CMakeLists.txt || die
}

src_prepare() {
	cmake-utils_src_prepare
	l10n_for_each_disabled_locale_do remove_from_LINGUAS
}

src_configure() {
	local mycmakeargs=(
		-DQT5=OFF
		-DWITH_SYSTEM_SINGLEAPP=ON
		$(cmake-utils_use debug)
		$(cmake-utils_use_with dbus)
		$(cmake-utils_use_with icoutils)
		$(cmake-utils_use_with wineappdb)
	)
	cmake-utils_src_configure
}
