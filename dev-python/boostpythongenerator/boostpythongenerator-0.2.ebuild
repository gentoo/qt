# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="dev-python/apiextractor
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s:share/cmake-2.6/Modules:share/cmake/Modules:" \
		"${S}/libbindgen/CMakeLists.txt" || die "sed failed"
}
