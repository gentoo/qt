# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

CMAKE_IN_SOURCE_BUILD="1"

PYTHON_DEPEND="2:2.6 3:3.2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.1 *-jython 2.7-pypy-*"

VIRTUALX_COMMAND="cmake-utils_src_test"

inherit multilib cmake-utils python virtualx git-2

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="X declarative help multimedia kde opengl phonon script scripttools sql svg test webkit xmlpatterns"

REQUIRED_USE="
	declarative? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	phonon? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	test? ( X )
	webkit? ( X )
"

QT_PV="4.7.0:4"

RDEPEND="
	~dev-python/shiboken-${PV}
	>=x11-libs/qt-core-${QT_PV}
	X? (
		>=x11-libs/qt-gui-${QT_PV}[accessibility]
		>=x11-libs/qt-test-${QT_PV}
	)
	declarative? ( >=x11-libs/qt-declarative-${QT_PV} )
	help? ( >=x11-libs/qt-assistant-${QT_PV} )
	multimedia? ( >=x11-libs/qt-multimedia-${QT_PV} )
	opengl? ( >=x11-libs/qt-opengl-${QT_PV} )
	phonon? (
		kde? ( media-libs/phonon )
		!kde? ( || (
			>=x11-libs/qt-phonon-${QT_PV}
			media-libs/phonon
		) )
	)
	script? ( >=x11-libs/qt-script-${QT_PV} )
	sql? ( >=x11-libs/qt-sql-${QT_PV} )
	svg? ( >=x11-libs/qt-svg-${QT_PV}[accessibility] )
	webkit? ( >=x11-libs/qt-webkit-${QT_PV} )
	xmlpatterns? ( >=x11-libs/qt-xmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	~dev-python/generatorrunner-${PV}
"

S=${WORKDIR}/${PN}

src_prepare() {
	# Fix generated pkgconfig file to require the shiboken
	# library suffixed with the correct python version.
	sed -i -e '/^Requires:/ s/shiboken$/&@SHIBOKEN_PYTHON_SUFFIX@/' \
		libpyside/pyside.pc.in || die

	python_src_prepare
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DPYTHON_SUFFIX="-python${PYTHON_ABI}"
			$(cmake-utils_use_build test TESTS)
			$(cmake-utils_use_disable X QtGui)
			$(cmake-utils_use_disable X QtDesigner)
			$(cmake-utils_use_disable X QtTest)
			$(cmake-utils_use_disable X QtUiTools)
			$(cmake-utils_use_disable declarative QtDeclarative)
			$(cmake-utils_use_disable help QtHelp)
			$(cmake-utils_use_disable multimedia QtMultimedia)
			$(cmake-utils_use_disable opengl QtOpenGL)
			$(cmake-utils_use_disable phonon)
			$(cmake-utils_use_disable script QtScript)
			$(cmake-utils_use_disable scripttools QtScriptTools)
			$(cmake-utils_use_disable sql QtSql)
			$(cmake-utils_use_disable svg QtSvg)
			$(cmake-utils_use_disable webkit QtWebKit)
			$(cmake-utils_use_disable xmlpatterns QtXmlPatterns)
		)
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
		CMAKE_USE_DIR="${BUILDDIR}" virtualmake
	}
	python_enable_pyc
	python_execute_function -s testing
	python_disable_pyc
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILDDIR}" cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-python${PYTHON_ABI}}.pc || die
	}
	python_execute_function -s installation
}
