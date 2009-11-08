# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

MY_PV="${PV/_p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A tool that controls bindings generation"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~dev-python/apiextractor-0.3.1
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -e 's/-2.6//' -i CMakeLists.txt || die "sed failed"
}
