# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-r1 virtualx git-r3

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"
EGIT_REPO_URI="https://code.qt.io/pyside/pyside-setup.git"
EGIT_BRANCH="5.9"

# See "sources/pyside2/PySide2/licensecomment.txt" for licensing details.
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="2"
KEYWORDS=""

#FIXME: Add support for a "speech" USE flag once an ebuild installing the
#"Qt5TextToSpeech" module is added.
IUSE="charts concurrent datavisualization declarative designer gui help
	multimedia network opengl printsupport script scripttools sql svg test
	testlib webchannel webengine webkit websockets widgets x11extras
	xmlpatterns"
	# speech

# The requirements below were extracted from the output of
# 'grep "set(.*_deps" "${S}"/PySide2/Qt*/CMakeLists.txt'
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	charts? ( widgets )
	datavisualization? ( gui )
	declarative? ( gui network )
	designer? ( widgets )
	help? ( widgets )
	multimedia? ( gui network )
	opengl? ( widgets )
	printsupport? ( widgets )
	scripttools? ( gui script widgets )
	sql? ( widgets )
	svg? ( widgets )
	testlib? ( widgets )
	webengine? ( gui network webchannel widgets )
	webkit? ( gui network printsupport widgets )
	websockets? ( network )
	widgets? ( gui )
	x11extras? ( gui )
"
	# speech? ( multimedia )

# Minimum version of Qt required, derived from the CMakeLists.txt line:
#   find_package(Qt5 ${QT_PV} REQUIRED COMPONENTS Core)
QT_PV="5.9*:5"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}:${SLOT}[${PYTHON_USEDEP}]
	=dev-qt/qtcore-${QT_PV}
	=dev-qt/qtxml-${QT_PV}
	charts? ( =dev-qt/qtcharts-${QT_PV} )
	concurrent? ( =dev-qt/qtconcurrent-${QT_PV} )
	datavisualization? ( =dev-qt/qtdatavis3d-${QT_PV} )
	declarative? ( =dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	designer? ( =dev-qt/designer-${QT_PV} )
	gui? ( =dev-qt/qtgui-${QT_PV} )
	help? ( =dev-qt/qthelp-${QT_PV} )
	multimedia? ( =dev-qt/qtmultimedia-${QT_PV}[widgets?] )
	network? ( =dev-qt/qtnetwork-${QT_PV} )
	opengl? ( =dev-qt/qtopengl-${QT_PV} )
	printsupport? ( =dev-qt/qtprintsupport-${QT_PV} )
	script? ( =dev-qt/qtscript-${QT_PV} )
	sql? ( =dev-qt/qtsql-${QT_PV} )
	svg? ( =dev-qt/qtsvg-${QT_PV} )
	testlib? ( =dev-qt/qttest-${QT_PV} )
	webchannel? ( =dev-qt/qtwebchannel-${QT_PV} )
	webengine? ( =dev-qt/qtwebengine-${QT_PV}[widgets] )
	webkit? ( =dev-qt/qtwebkit-${QT_PV}[printsupport] )
	websockets? ( =dev-qt/qtwebsockets-${QT_PV} )
	widgets? ( =dev-qt/qtwidgets-${QT_PV} )
	x11extras? ( =dev-qt/qtx11extras-${QT_PV} )
	xmlpatterns? ( =dev-qt/qtxmlpatterns-${QT_PV} )
"
	# speech? ( =dev-qt/qtspeech-${QT_PV} )
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/sources/pyside2

src_prepare() {
	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# See COLLECT_MODULE_IF_FOUND macros in CMakeLists.txt
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Charts=$(usex !charts)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DataVisualization=$(usex !datavisualization)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5OpenGL=$(usex !opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !declarative yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=$(usex !scripttools)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !testlib)
		# -DCMAKE_DISABLE_FIND_PACKAGE_Qt5TextToSpeech=$(usex !speech)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKit=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKitWidgets=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebSockets=$(usex !websockets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=$(usex !widgets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5X11Extras=$(usex !x11extras)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5XmlPatterns=$(usex !xmlpatterns)
	)

	configuration() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE
	python_foreach_impl virtx cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
