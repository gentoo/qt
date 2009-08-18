# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Library used to create an internal representation of an API in order to create Python bindings"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/lib${PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.38.0
	>=x11-libs/qt-core-4.5.0
	>=x11-libs/qt-xmlpatterns-4.5.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/lib${PN}-${PV}"

src_prepare() {
	sed -i "s:share/cmake-2.6/Modules:share/cmake/Modules:" \
		"${S}/CMakeLists.txt" || die "sed failed"
}
