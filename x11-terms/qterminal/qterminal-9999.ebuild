# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Qt4-based multitab terminal emulator"
HOMEPAGE="https://gitorious.org/qterminal"
EGIT_REPO_URI="git://gitorious.org/qterminal/qterminal.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qtermwidget"
RDEPEND="${DEPEND}"

#todo: translations
