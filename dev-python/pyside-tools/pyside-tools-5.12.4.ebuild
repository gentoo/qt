# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
CMAKE_IN_SOURCE_BUILD=1

inherit cmake-utils python-r1 virtualx

MY_P=pyside-setup-everywhere-src-${PV}

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"

# Although "LICENSE-uic" suggests the "pyside2uic" directory to be dual-licensed
# under the BSD 3-clause and GPL v2 licenses, this appears to be an oversight;
# all files in this (and every) directory are licensed only under the GPL v2.
LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The "pyside2uic" package imports the "PySide2.QtGui" and "PySide2.QtWidgets"
# C extensions and thus requires "widgets", which includes "gui" as well.
RDEPEND="${PYTHON_DEPS}
	>=dev-python/pyside-${PV}:${SLOT}[widgets,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( virtual/pkgconfig )
"

S=${WORKDIR}/${MY_P}/sources/pyside2-tools
DOCS=( AUTHORS README.md )

src_prepare() {
	cmake-utils_src_prepare

	python_copy_sources

	pyside-tools_prepare() {
		pushd "${BUILD_DIR}" >/dev/null || die

		if python_is_python3; then
			# Remove Python 2-specific paths.
			rm -rf pyside2uic/port_v2 || die

			# Generate proper Python 3 test interfaces with the "-py3" option.
			sed -i -e 's:${PYSIDERCC_EXECUTABLE}:"${PYSIDERCC_EXECUTABLE} -py3":' \
				tests/rcc/CMakeLists.txt || die
		else
			# Remove Python 3-specific paths.
			rm -rf pyside2uic/port_v3 || die
		fi

		# Force testing against the current Python version.
		sed -i -e "/pkg-config/ s:shiboken2:&-${EPYTHON}:" \
			tests/rcc/run_test.sh || die

		popd >/dev/null || die
	}
	python_foreach_impl pyside-tools_prepare
}

src_configure() {
	pyside-tools_configure() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		)
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_configure
	}
	python_foreach_impl pyside-tools_configure
}

src_compile() {
	pyside-tools_compile() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_compile
	}
	python_foreach_impl pyside-tools_compile
}

src_test() {
	pyside-tools_test() {
		local -x PYTHONDONTWRITEBYTECODE
		CMAKE_USE_DIR="${BUILD_DIR}" virtx cmake-utils_src_test
	}
	python_foreach_impl pyside-tools_test
}

src_install() {
	pyside-tools_install() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install
	}
	python_foreach_impl pyside-tools_install
}
