# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
LANGS="de en it pl pt ru"

inherit qt4-edge

DESCRIPTION="Slideshow Maker In Linux Environement"
HOMEPAGE="http://smile.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/smiletool/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="media-sound/sox
	media-video/mplayer
	x11-libs/qt-opengl:4
	x11-libs/qt-webkit:4
	media-gfx/imagemagick"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/fix_installation.patch"
	"${FILESDIR}/fix_docs-${PV}.patch"
)

S="${WORKDIR}/${PN}"

src_install() {
	dobin smile || die "dobin failed"
	doicon Interface/Theme/${PN}.png || die "doicon failed"
	make_desktop_entry smile Smile smile "Qt;AudioVideo;Video"

	dodoc BIB_ManSlide/Help/doc_en.html
	dodoc BIB_ManSlide/Help/doc_fr.html
	insinto /usr/share/doc/${PF}/
	doins -r BIB_ManSlide/Help/images
	doins -r BIB_ManSlide/Help/images_en
	doins -r BIB_ManSlide/Help/images_fr
	prepare_translations
}
