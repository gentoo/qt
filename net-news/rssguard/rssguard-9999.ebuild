# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils git-2

DESCRIPTION="A tiny RSS and Atom feed reader"
HOMEPAGE="http://code.google.com/p/rss-guard/"
#SRC_URI="http://rss-guard.googlecode.com/files/${P}-src.tar.gz"
EGIT_REPO_URI="http://code.google.com/p/rss-guard/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="dbus"

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-webkit:4
	x11-libs/qt-xmlpatterns:4
	x11-themes/hicolor-icon-theme
	dbus? ( x11-libs/qt-dbus:4 )"
RDEPEND="${DEPEND}"

DOCS=( resources/text/AUTHORS resources/text/CHANGELOG )
