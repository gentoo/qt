# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2 git-2

DESCRIPTION="Qt utility to change Xcrusor themes without restarting X Server."
HOMEPAGE="http://gitorious.org/qt-xcurtheme"
EGIT_REPO_URI="git://gitorious.org/qt-xcurtheme/mainline"

LICENSE="GPL-2 WTFPL-2"
SLOT="0"
KEYWORDS=""
IUSE="tools"

DEPEND="
	dev-qt/qtgui:4
	x11-libs/libXcursor
	x11-libs/libXfixes
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "/QMAKE_LFLAGS_RELEASE/d" xct.pro ||
		die "xct.pro sed failed";
	sed -i "/QMAKE_LFLAGS_RELEASE/d" tools/cursorFXconvert/lcft.pro ||
		die	"lcft.pro sed failed";
}

src_configure() {
	qt4-r2_src_configure
	if use tools; then
		pushd tools/cursorFXconvert/ > /dev/null || die
		eqmake4
		popd > /dev/null || die
	fi
}

src_compile() {
	qt4-r2_src_compile
	if use tools; then
		pushd tools/cursorFXconvert/ > /dev/null || die
		emake
		popd > /dev/null || die
	fi
}

src_install() {
	dobin "${PN}"
	if use tools; then
		pushd tools/cursorFXconvert/ > /dev/null || die
		dobin lcft
		popd > /dev/null || die
	fi
}
