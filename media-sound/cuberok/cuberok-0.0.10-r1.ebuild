# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit multilib qt4-edge

DESCRIPTION="Qt4 lightweight music player"
HOMEPAGE="http://code.google.com/p/cuberok/"
SRC_URI="http://cuberok.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mp3"

DEPEND="media-libs/gstreamer
	media-libs/taglib
	x11-libs/qt-gui:4
	x11-libs/qt-sql:4"
RDEPEND="${DEPEND}
	mp3? ( media-plugins/gst-plugins-mad )"

src_install() {
	emake INSTALL_ROOT="${D}/usr" install || die "emake install failed"
	dodoc ChangeLog || die
	doicon images/cuberok.png || die
}
