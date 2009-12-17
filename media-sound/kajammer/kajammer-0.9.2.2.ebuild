# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Simple Qt audio player"
HOMEPAGE="http://sourceforge.net/projects/kajammer/"
SRC_URI="mirror://sourceforge/${PN}/${P}-1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	kde? ( media-sound/phonon )
	!kde? ( x11-libs/qt-phonon:4 )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's:/usr/share/icons:/usr/share/pixmaps:' \
		CMakeLists.txt || die "sed failed"
}

src_install() {
	cmake-utils_src_install

	dodoc Changelog README || die
}
