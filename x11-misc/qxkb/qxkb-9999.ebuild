# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils subversion

DESCRIPTION="Qt4-based keyboard layout switcher"
HOMEPAGE="http://code.google.com/p/qxkb/"
ESVN_REPO_URI="http://qxkb.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	x11-libs/libxkbfile
"
RDEPEND="${DEPEND}
	x11-apps/setxkbmap
"

src_prepare() {
	sed -i -e 's:../language:${CMAKE_SOURCE_DIR}/language:' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}
