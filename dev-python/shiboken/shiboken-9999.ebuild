# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

CMAKE_IN_SOURCE_BUILD="1"

PYTHON_DEPEND="2:2.6 3:3.2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.1 *-jython 2.7-pypy-*"

inherit multilib cmake-utils python git-2

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/pyside/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	~dev-python/apiextractor-${PV}
	~dev-python/generatorrunner-${PV}
	>=x11-libs/qt-core-4.7.0:4
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	# Fix inconsistent naming of libshiboken.so and ShibokenConfig.cmake,
	# caused by the usage of a different version suffix with python >= 3.2
	sed -i -e "/get_config_var('SOABI')/d" \
		cmake/Modules/FindPython3InterpWithDebug.cmake || die

	python_src_prepare
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DPYTHON_EXECUTABLE="$(PYTHON -a)"
			-DPYTHON_SUFFIX="-python${PYTHON_ABI}"
			$(cmake-utils_use_build test TESTS)
		)

		if [[ $(python_get_version -l --major) == 3 ]]; then
			mycmakeargs+=(
				-DUSE_PYTHON3=ON
				-DPYTHON3_INCLUDE_DIR="$(python_get_includedir)"
				-DPYTHON3_LIBRARY="$(python_get_library)"
			)
		fi

		CMAKE_USE_DIR="${BUILDDIR}" cmake-utils_src_configure
	}
	python_execute_function -s configuration
}

src_compile() {
	compilation() {
		CMAKE_USE_DIR="${BUILDDIR}" cmake-utils_src_make
	}
	python_execute_function -s compilation
}

src_test() {
	testing() {
		CMAKE_USE_DIR="${BUILDDIR}" cmake-utils_src_test
	}
	python_execute_function -s testing
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILDDIR}" cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-python${PYTHON_ABI}}.pc || die
	}
	python_execute_function -s installation
}
