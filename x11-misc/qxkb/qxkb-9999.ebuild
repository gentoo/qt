# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils subversion

DESCRIPTION="Qt4-based keyboard layout switcher"
HOMEPAGE="http://code.google.com/p/qxkb/"
ESVN_REPO_URI="http://qxkb.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/libxkbfile
	dev-qt/qtgui:4
	dev-qt/qtsvg:4"
RDEPEND="${DEPEND}"

#todo: translations
