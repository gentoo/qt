# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Simple Qt audio player"
HOMEPAGE="http://sourceforge.net/projects/kajammer/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lastfm"

DEPEND="media-libs/phonon[qt4]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	lastfm? ( media-libs/liblastfm )"
RDEPEND="${DEPEND}"

DOCS="Changelog README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	epatch "${FILESDIR}"/${P}-desktopfile.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch

	if ! use lastfm ; then
		# avoid automagic dep
		sed -i -e '/FIND_PACKAGE( LastFM )/d' \
			-e '/^FIND_PATH( HAVE_LASTFM_H/d' \
			CMakeLists.txt || die "sed failed"
	fi
}
