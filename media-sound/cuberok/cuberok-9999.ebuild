# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit qt4-edge subversion

DESCRIPTION="Qt4 lightweight music player"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Cuberok?content=97885"
ESVN_REPO_URI="http://cuberok.googlecode.com/svn/trunk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=media-libs/gstreamer-0.10
	<x11-libs/qt-gui-4.9999
	<x11-libs/qt-sql-4.9999"
RDEPEND="${DEPEND}
	media-libs/taglib"

src_configure(){
	eqmake4 Cuberok.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	doicon images/${PN}.png
	make_desktop_entry cuberok Cuberok ${PN}.png 'Qt;AudioVideo;Audio' \
		die || "make_desktop_entry_failed"
}
