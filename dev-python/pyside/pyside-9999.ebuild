# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit cmake-utils flag-o-matic python-r1 virtualx git-r3

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/Pyside"
EGIT_REPO_URI=(
	"git://code.qt.io/pyside/${PN}.git"
	"https://code.qt.io/git/pyside/${PN}.git"
)

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

IUSE="X declarative designer help multimedia opengl script scripttools sql svg test webkit xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( X )
	designer? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	test? ( X )
	webkit? ( X )
"

# Minimal supported version of Qt.
QT_PV="4.8.5:4"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	X? (
		>=dev-qt/qtgui-${QT_PV}[accessibility]
		>=dev-qt/qttest-${QT_PV}
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	script? ( >=dev-qt/qtscript-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV}[accessibility] )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtgui-${QT_PV}
"

DOCS=( ChangeLog )

src_prepare() {
	# Fix generated pkgconfig file to require the shiboken
	# library suffixed with the correct python version.
	sed -i -e '/^Requires:/ s/shiboken$/&@SHIBOKEN_PYTHON_SUFFIX@/' \
		libpyside/pyside2.pc.in || die

	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDISABLE_QtGui=$(usex !X)
		-DDISABLE_QtTest=$(usex !X)
		-DDISABLE_QtQml=$(usex !declarative)
		-DDISABLE_QtQuick=$(usex !declarative)
		-DDISABLE_QtQuickWidgets=$(usex !declarative)
		-DDISABLE_QtUiTools=$(usex !designer)
		-DDISABLE_QtHelp=$(usex !help)
		-DDISABLE_QtMultimedia=$(usex !multimedia)
		-DDISABLE_QtOpenGL=$(usex !opengl)
		-DDISABLE_QtScript=$(usex !script)
		-DDISABLE_QtScriptTools=$(usex !scripttools)
		-DDISABLE_QtSql=$(usex !sql)
		-DDISABLE_QtSvg=$(usex !svg)
		-DDISABLE_QtWebKit=$(usex !webkit)
		-DDISABLE_QtXmlPatterns=$(usex !xmlpatterns)
	)

	configuration() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local PYTHONDONTWRITEBYTECODE
	export PYTHONDONTWRITEBYTECODE

	VIRTUALX_COMMAND="cmake-utils_src_test" python_foreach_impl virtualmake
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
