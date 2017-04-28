# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils llvm python-r1 git-r3

DESCRIPTION="Tool for creating Python bindings for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"
EGIT_REPO_URI=(
	"git://code.qt.io/pyside/shiboken.git"
	"https://code.qt.io/git/pyside/shiboken.git"
)

#FIXME: Switch to the clang-enabled "dev" branch once stable.
EGIT_BRANCH="5.6"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Minimum version of Qt required.
QT_PV=":5/5.6"

#FIXME: Add "sys-devel/clang:*" after switching to the "dev" branch.
RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/libxml2-2.6.32
	>=dev-libs/libxslt-1.1.19
	dev-qt/qtcore${QT_PV}
	dev-qt/qtxml${QT_PV}
	dev-qt/qtxmlpatterns${QT_PV}
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui${QT_PV}
		dev-qt/qttest${QT_PV}
	)
"

DOCS=( AUTHORS )

src_prepare() {
	#FIXME: Uncomment after switching to the "dev" branch.
	# sed -i -e '/^find_library(CLANG_LIBRARY/ s~/lib)$~/'$(get_libdir)')~' \
	# 	CMakeLists.txt || die

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

		#FIXME: Uncomment after switching to the "dev" branch.
		#FIXME: "CMakeLists.txt" currently requires that callers manually set
		#this environment variable to the absolute path of the directory
		#containing clang libraries rather than magically finding this path
		#(e.g., via "find_package(CLang)"). If this changes, remove this option.
		# CLANG_INSTALL_DIR="$(get_llvm_prefix)" cmake-utils_src_configure

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
