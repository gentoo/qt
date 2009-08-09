# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge git

DESCRIPTION="Qt4 application to adjust layouts by xkb"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Antico+XKB?content=101667"
EGIT_REPO_URI="git://github.com/disels/axkb.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/libxkbfile
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4"
RDEPEND="${DEPEND}"

DOCS="NEWS"
