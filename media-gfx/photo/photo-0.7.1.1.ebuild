# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Simple but powerful Qt4-based image viewer"
HOMEPAGE="http://qt-apps.org/content/show.php/Photo?content=147453"
SRC_URI="http://qt-apps.org/CONTENT/content-files/147453-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-gfx/exiv2
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-install-desktop.patch
}

#TODO: translations
