# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit multilib qt4-edge

DESCRIPTION="Qt4 lightweight music player"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Cuberok?content=97885"
SRC_URI="http://cuberok.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mp3"

DEPEND="media-libs/gstreamer
	x11-libs/qt-gui:4
	x11-libs/qt-sql:4
	mp3? ( media-plugins/gst-plugins-mad )"
RDEPEND="${DEPEND}
	media-libs/taglib"

src_prepare(){
	#fixing multilib issues
	for target in cuberok_style/cuberok_style.pro player_gst/player_gst.pro;do
		einfo "fixing ${target}"
		sed -i "s/lib\/cuberok/$(get_libdir)\/cuberok/" \
		"${S}"/plugins/${target} || die "seding ${target} failed"
	done
}

src_configure(){
	eqmake4 Cuberok.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	doicon images/${PN}.png
	make_desktop_entry cuberok Cuberok ${PN}.png 'Qt;AudioVideo;Audio' \
		die || "make_desktop_entry_failed"
}
