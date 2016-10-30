# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit cmake-utils python-r1 git-r3

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="https://wiki.qt.io/Pyside"
EGIT_REPO_URI=(
	"git://code.qt.io/pyside/${PN}.git"
	"https://code.qt.io/git/pyside/${PN}.git"
)

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2
	dev-libs/libxslt
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui:5
		dev-qt/qttest:5
	)
"

DOCS=( AUTHORS )

src_prepare() {
	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
		)

		if [[ ${EPYTHON} == python3* ]]; then
			mycmakeargs+=(
				-DUSE_PYTHON_VERSION=3
			)
		fi

		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
