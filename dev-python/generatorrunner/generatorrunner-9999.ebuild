# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="A tool to control bindings generation"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/pyside/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug test"

QT_PV="4.7.0:4"

RDEPEND="
	~dev-python/apiextractor-${PV}
	>=x11-libs/qt-core-${QT_PV}
"
DEPEND="${RDEPEND}
	test? ( >=x11-libs/qt-test-${QT_PV} )
"

S=${WORKDIR}/${PN}

DOCS=( AUTHORS )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
	)
	cmake-utils_src_configure
}
