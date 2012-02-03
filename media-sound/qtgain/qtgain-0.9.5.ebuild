# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qtgain/qtgain-0.8.0.ebuild,v 1.1 2009/12/23 21:57:04 ssuominen Exp $

EAPI="4"
inherit qt4-r2

DESCRIPTION="A simple frontend to mp3gain, vorbisgain and metaflac"
HOMEPAGE="http://www.qt-apps.org/content/show.php/QtGain?content=56842"
SRC_URI="http://www.qt-apps.org/CONTENT/content-files/56842-QtGain.tar.lzma
	-> ${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 mp4 vorbis"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}
	flac? ( media-libs/flac )
	mp3? ( media-sound/mp3gain )
	mp4? ( media-sound/aacgain )
	vorbis? ( media-sound/vorbisgain )
	media-sound/id3v2"

S="${WORKDIR}/QtGain"

src_install() {
	dobin bin/qtgain || die
	newicon Icons/lsongs.png qtgain.png
	make_desktop_entry qtgain QtGain
}
