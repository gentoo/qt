# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD="1"

#FIXME: Restore Python 2.7 support after this upstream issue is resolved:
#    https://bugreports.qt.io/browse/PYSIDE-508
#Even after this issue is resolved, further ebuild changes will probably be
#needed to fully support Python 2.7. Unlike PySide2 and Shiboken2, the root
#"CMakeLists.txt" file in pyside2-tools provides no ${PYTHON_EXECUTABLE} option.
#Instead, the ${PYTHON_EXTENSION_SUFFIX} and ${PYTHON_BASENAME} options must be
#passed with values specific to Python 2.7. Additionally, note that the
#"python2.7-config" command provides no "--extension-suffix" option.
PYTHON_COMPAT=( python3_{4,5,6} )

inherit cmake-utils python-r1 virtualx git-r3

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="https://wiki.qt.io/PySide2"
EGIT_REPO_URI=(
	"git://code.qt.io/pyside/${PN}.git"
	"https://code.qt.io/git/pyside/${PN}.git"
)
#FIXME: Switch to the clang-enabled "dev" branch once stable.
EGIT_BRANCH="5.6"

LICENSE="BSD GPL-2"
SLOT="2"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The "pyside2uic" package imports both the "PySide2.QtGui" and
# "PySide2.QtWidgets" C extensions and hence requires "gui" and "widgets".
RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/pyside-${PV}:${SLOT}[gui,widgets,${PYTHON_USEDEP}]
	>=dev-python/shiboken-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}
	test? ( virtual/pkgconfig )
"

src_prepare() {
	cmake-utils_src_prepare

	python_copy_sources

	preparation() {
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
	python_foreach_impl preparation
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
		)

		if python_is_python3; then
			# Extension tag unique to the current Python 3.x version (e.g.,
			# ".cpython-34m" for CPython 3.4).
			local EXTENSION_TAG="$("$(python_get_PYTHON_CONFIG)" --extension-suffix)"
			EXTENSION_TAG="${EXTENSION_TAG%.so}"

			mycmakeargs+=(
				#FIXME: Submit an upstream PySide2 issue requesting that the
				#"PySide2Config.cmake" file use the same
				#${PYTHON_EXTENSION_SUFFIX} variable as the
				#"Shiboken2Config.cmake" file.

				# Find the previously installed "Shiboken2Config.*.cmake" and
				# "PySide2Config.*.cmake" files specific to this Python 3.x
				# version.
				-DPYTHON_EXTENSION_SUFFIX="${EXTENSION_TAG}"
				-DPYTHON_BASENAME="${EXTENSION_TAG}"
			)
		else
			die "Python 2.7 currently unsupported."
		fi

		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_compile
	}
	python_foreach_impl compilation
}

src_test() {
	testing() {
		local -x PYTHONDONTWRITEBYTECODE
		CMAKE_USE_DIR="${BUILD_DIR}" virtx cmake-utils_src_test
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install
	}
	python_foreach_impl installation
}
