# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

DESCRIPTION="Qt4 lightweight music player"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Cuberok?content=97885"
SRC_URI="http://cuberok.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="<=x11-libs/qt-gui-4.4.9999
	<=x11-libs/qt-sql-4.4.9999"
RDEPEND="${DEPEND}
	media-libs/libpng
	media-libs/freetype
	media-libs/taglib"

src_compile(){
	eqmake4 Cuberok.pro || die "eqmake4 failed"
	emake || die "emake failed"
}

src_install() {
	dobin unix/cuberok
	doicon images/${PN}.png
	make_desktop_entry cuberok Cuberok ${PN}.png 'Qt;AudioVideo;Audio' \
		|| die "make_desktop_entry failed"
}
