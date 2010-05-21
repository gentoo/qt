# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

DESCRIPTION="Simple Qt4 crossplatform ID3v2 tag editor"
HOMEPAGE="http://qtagger.googlecode.com"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/taglib
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	#fix docs installation
	sed -i "s/doc\/${PN}/doc\/${PF}/" CMakeLists.txt
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_RPATH=/usr/$(get_libdir)
		-DCMAKE_NO_BUILTIN_CHRPATH:BOOL=ON"
	cmake-utils_src_configure
}
