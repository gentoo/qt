# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils llvm python-r1 git-r3

DESCRIPTION="Tool for creating Python bindings for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"
EGIT_REPO_URI=(
	"git://code.qt.io/pyside/pyside-setup.git"
	"https://code.qt.io/git/pyside/pyside-setup.git"
)
#FIXME: Switch to the clang-enabled "dev" branch once stable.
EGIT_BRANCH="5.6"

LICENSE="|| ( GPL-2+ LGPL-3 ) GPL-3"
SLOT="2"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Minimum version of Qt required.
QT_PV="5.6:5"

#FIXME: Add "sys-devel/clang:*" after switching to the "dev" branch.
DEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtxml-${QT_PV}
	>=dev-qt/qtxmlpatterns-${QT_PV}
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/sources/shiboken2

DOCS=( AUTHORS )

src_prepare() {
	#FIXME: Uncomment after switching to the "dev" branch.
	# sed -i -e "/^find_library(CLANG_LIBRARY/ s~/lib)$~/$(get_libdir))~" CMakeLists.txt || die

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
		)

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
