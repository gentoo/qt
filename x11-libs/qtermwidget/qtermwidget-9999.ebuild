# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Qt4 terminal emulator widget"
HOMEPAGE="https://github.com/qterminal/"
EGIT_REPO_URI="git://github.com/qterminal/qtermwidget.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug" # todo: python

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"
