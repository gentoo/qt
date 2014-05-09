# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Qt4-based filemanager"
HOMEPAGE="https://gitorious.org/andromeda/pages/Home"
EGIT_REPO_URI="git://gitorious.org/$PN/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=">=dev-qt/qtcore-4.8.0:4
	>=dev-qt/qtgui-4.8.0:4
	>=dev-qt/qtwebkit-4.8.0:4"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-4.8.0:4 )"
DOCS="TODO.txt dist/changes-*"

src_prepare() {
	if ! use test ; then
		sed -i -e '/add_subdirectory( tests )/d' CMakeLists.txt || die
	fi
}
