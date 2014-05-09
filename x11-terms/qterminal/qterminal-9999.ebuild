# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Qt4-based multitab terminal emulator"
HOMEPAGE="https://github.com/qterminal/"
EGIT_REPO_URI="git://github.com/qterminal/qterminal.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-qt/qtgui:4
	x11-libs/libqxt
	x11-libs/qtermwidget"
RDEPEND="${DEPEND}"

#todo: translations
