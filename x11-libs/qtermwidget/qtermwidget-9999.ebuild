# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Qt4 terminal emulator widget"
HOMEPAGE="https://gitorious.org/qtermwidget"
EGIT_REPO_URI="git://gitorious.org/qtermwidget/qtermwidget.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug" # todo: python

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

