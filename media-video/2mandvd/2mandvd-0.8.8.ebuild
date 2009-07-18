# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="de en ru"

inherit qt4-edge

MY_PN="2ManDVD"

DESCRIPTION="The successor of ManDVD"
HOMEPAGE="http://kde-apps.org/content/show.php?content=99450"
SRC_URI="http://download.tuxfamily.org/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="media-video/dvdauthor
	media-video/ffmpegthumbnailer
	media-fonts/dejavu
	media-sound/sox
	media-video/mplayer
	media-libs/netpbm
	media-video/mjpegtools
	app-cdr/cdrkit
	media-libs/xine-lib
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	cd "${S}"
	# fix installation path
	for file in media_browser.cpp rendering.cpp;do
		sed -i "s/qApp->applicationDirPath()+\"/\"\/usr\/share\/${PN}\//" \
			${file} || die "sed failed"
	done
	sed -i "s/qApp->applicationDirPath()+\"/\"\/usr\/share\/${PN}\//" \
		mainfrm.cpp || die "sed failed"
	sed -i "s/qApp->applicationDirPath()/\"\/usr\/share\/${PN}\/\"/" \
		mainfrm.cpp || die "sed failed"
	qt4-edge_src_prepare
}

src_install() {
	dobin 2ManDVD || die "dobin failed"
	insinto /usr/share/${PN}/
	doins -r Bibliotheque || die "failed to install Bibliotheque"
	doins -r Interface || die "failed to install Interface"
	doicon Interface/mandvdico.png
	# Desktop icon
	make_desktop_entry 2ManDVD 2ManDVD mandvdico "Qt;AudioVideo;Video" \
		die "make_desktop_entry failed"
	prepare_translations
}
