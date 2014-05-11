# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils git-2

DESCRIPTION="ebook reader"
HOMEPAGE="http://www.coolreader.org/"
EGIT_REPO_URI="git://crengine.git.sourceforge.net/gitroot/crengine/crengine"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/freetype
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	virtual/ttf-fonts"

src_prepare() {
	use amd64 && \
		sed -e 's/unsigned int/unsigned long/g' -i crengine/src/lvdocview.cpp \
			|| die 'sed lvdocview.cpp failed'
}

src_configure() {
	CMAKE_BUILD_TYPE="Release"
	mycmakeargs="-D GUI=QT"
	cmake-utils_src_configure
}
