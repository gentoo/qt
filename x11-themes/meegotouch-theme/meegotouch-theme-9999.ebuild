# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 git

DESCRIPTION="The Harmattan development theme"
HOMEPAGE="http://duiframework.wordpress.com"
EGIT_REPO_URI="git://gitorious.org/meegotouch/meegotouch-theme.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-core:4
	!x11-themes/duitheme"
RDEPEND=">=x11-libs/qt-svg-4.7.0:4"
