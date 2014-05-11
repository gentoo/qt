# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils

DESCRIPTION="Common libraries for the Razor-qt desktop environment"
HOMEPAGE="http://razor-qt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="https://github.com/downloads/Razor-qt/razor-qt/razorqt-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/razorqt-${PV}"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="razorqt-base/libqtxdg
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrender
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	!x11-wm/razorqt"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSPLIT_BUILD=On
		-DMODULE_LIBRAZORQT=On
		-DMODULE_LIBRAZORQXT=On
		-DMODULE_LIBRAZORMOUNT=On
		-DMODULE_LIBRAZORGLOBALKEYSHORTCUTSCLIENT=On
		-DMODULE_LIBRAZORGLOBALKEYSHORTCUTSBUTTON=On
		-DMODULE_LIBSYSSTAT=On
		-DMODULE_ABOUT=On
		-DMODULE_X11INFO=On
	)
	cmake-utils_src_configure
}
