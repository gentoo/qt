# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="A blogging client based on the Qt"
HOMEPAGE="http://qtm.blogistan.co.uk"
SRC_URI="mirror://sourceforge/catkin/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
RESTRICT="strip"

RDEPEND="x11-libs/qt-gui:4[debug?]
	x11-proto/xproto
	dev-lang/perl
	virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

CMAKE_IN_SOURCE_BUILD="1"

DOCS="README"

src_configure() {
	mycmakeargs="-DUSE_STI=TRUE -DDONT_USE_PTE=FALSE -DINSTALL_MARKDOWN=TRUE $(cmake-utils_use debug QDEBUG)"
	cmake-utils_src_configure
}
