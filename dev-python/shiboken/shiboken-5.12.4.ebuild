# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Split the "/usr/bin/shiboken2" binding generator from the
# "/usr/lib64/libshiboken2-*.so" family of shared libraries. The former
# requires everything (including Clang) at runtime; the latter only requires
# Qt and Python at runtime. Note that "pip" separates these two as well. See:
# https://doc.qt.io/qtforpython/shiboken2/faq.html#is-there-any-runtime-dependency-on-the-generated-binding
# Once split, the PySide2 ebuild should be revised to require
# "/usr/bin/shiboken2" at build time and "libshiboken2-*.so" at runtime.

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit cmake-utils llvm python-r1

MY_P=pyside-setup-everywhere-src-${PV}

DESCRIPTION="Python binding generator for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"

# The "sources/shiboken2/libshiboken" directory is triple-licensed under the
# GPL v2, v3+, and LGPL v3. All remaining files are licensed under the GPL v3
# with version 1.0 of a Qt-specific exception enabling shiboken2 output to be
# arbitrarily relicensed. (TODO)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 ) GPL-3"
SLOT="2"
KEYWORDS="~amd64"
IUSE="+docstrings numpy test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-qt/qtcore-${PV}:5
	>=sys-devel/clang-6:=
	docstrings? (
		>=dev-libs/libxml2-2.6.32
		>=dev-libs/libxslt-1.1.19
		>=dev-qt/qtxml-${PV}:5
		>=dev-qt/qtxmlpatterns-${PV}:5
	)
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-${PV}:5 )
"

S=${WORKDIR}/${MY_P}/sources/shiboken2
DOCS=( AUTHORS )

# Ensure the path returned by get_llvm_prefix() contains clang as well.
llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	#FIXME: File an upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/print(os\.path\.realpath(numpy))/d' \
			libshiboken/CMakeLists.txt || die
	fi

	# CMakeLists.txt assumes clang builtin includes are installed under
	# LLVM_INSTALL_DIR. They are not on Gentoo. See bug 624682.
	sed -i -e "s~clangPathLibDir = findClangLibDir()~clangPathLibDir = QStringLiteral(\"${EPREFIX}/usr/lib\")~" \
		ApiExtractor/clangparser/compilersupport.cpp || die

	cmake-utils_src_prepare
}

src_configure() {
	shiboken_configure() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
			-DDISABLE_DOCSTRINGS=$(usex !docstrings)
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DUSE_PYTHON_VERSION="${EPYTHON#python}"
		)
		# CMakeLists.txt expects LLVM_INSTALL_DIR as an environment variable.
		LLVM_INSTALL_DIR="$(get_llvm_prefix)" cmake-utils_src_configure
	}
	python_foreach_impl shiboken_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	shiboken_install() {
		cmake-utils_src_install
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl shiboken_install
}
