# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit cmake-utils python-r1 virtualx

# TODO: Add conditional support for "QtRemoteObjects" via a new "remoteobjects"
# USE flag after an external "dev-qt/qtremoteobjects" package has been created.
# TODO: Add conditional support for apidoc generation via a new "doc" USE flag.
# Note that doing so requires the Qt source tree, sphinx, and graphviz.
# TODO: Disable GLES support if the "gles2" USE flag is disabled. Note that
# "PySide2/QtGui/CMakeLists.txt" and "PySide2/QtOpenGLFunctions/CMakeLists.txt"
# test for GLES support by testing whether the "Qt5::Gui" property defined by
# "/usr/lib64/cmake/Qt5Gui/Qt5GuiConfig.cmake" at "dev-qt/qtgui" installation
# time contains the substring "opengles2". Since cmake properties cannot be
# overridden by CLI options, these files must instead be conditionally patched
# to avoid these tests. An issue should be filed with upstream requesting a
# CLI-settable cmake variable to control this.

MY_P=pyside-setup-everywhere-src-${PV}

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"

# See "sources/pyside2/PySide2/licensecomment.txt" for licensing details.
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="2"
KEYWORDS="~amd64"
IUSE="3d charts concurrent datavis designer gles2 gui help location multimedia
	network positioning printsupport qml quick script scripttools scxml sensors
	speech sql svg test testlib webchannel webengine websockets widgets
	x11extras xml xmlpatterns"

# Manually reextract these requirements on version bumps by running the
# following one-liner from within "${S}":
#     $ grep 'set\(.*_deps' PySide2/Qt*/CMakeLists.txt
# Note that the "designer" USE flag corresponds to the "Qt5UiTools" module.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	3d? ( gui network )
	charts? ( widgets )
	datavis? ( gui )
	designer? ( widgets xml )
	gles2? ( gui )
	help? ( widgets )
	location? ( positioning )
	multimedia? ( gui network )
	printsupport? ( widgets )
	qml? ( gui network )
	quick? ( qml )
	scripttools? ( gui script widgets )
	speech? ( multimedia )
	sql? ( widgets )
	svg? ( widgets )
	testlib? ( widgets )
	webengine? ( widgets? ( gui network printsupport webchannel ) )
	websockets? ( network )
	widgets? ( gui )
	x11extras? ( gui )
"

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-2):5"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}:${SLOT}[${PYTHON_USEDEP}]
	3d? ( >=dev-qt/qt3d-${QT_PV}[qml?] )
	charts? ( >=dev-qt/qtcharts-${QT_PV}[qml?] )
	concurrent? ( >=dev-qt/qtconcurrent-${QT_PV} )
	datavis? ( >=dev-qt/qtdatavis3d-${QT_PV}[qml?] )
	designer? ( >=dev-qt/designer-${QT_PV} )
	gui? ( >=dev-qt/qtgui-${QT_PV}[gles2?] )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	location? ( >=dev-qt/qtlocation-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV}[qml?,widgets?] )
	network? ( >=dev-qt/qtnetwork-${QT_PV} )
	positioning? ( >=dev-qt/qtpositioning-${QT_PV}[qml?] )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_PV} )
	qml? ( >=dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	script? ( >=dev-qt/qtscript-${QT_PV} )
	scxml? ( >=dev-qt/qtscxml-${QT_PV} )
	sensors? ( >=dev-qt/qtsensors-${QT_PV}[qml?] )
	speech? ( >=dev-qt/qtspeech-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	testlib? ( >=dev-qt/qttest-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV}[qml?] )
	webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets?] )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV}[qml?] )
	widgets? ( >=dev-qt/qtwidgets-${QT_PV} )
	x11extras? ( >=dev-qt/qtx11extras-${QT_PV} )
	xml? ( >=dev-qt/qtxml-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV}[qml?] )
"
DEPEND="${RDEPEND}
	test? ( x11-misc/xvfb-run )
"

S=${WORKDIR}/${MY_P}/sources/pyside2

src_configure() {
	# See COLLECT_MODULE_IF_FOUND macros in CMakeLists.txt
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DAnimation=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DCore=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DExtras=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DInput=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DLogic=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DRender=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Charts=$(usex !charts)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DataVisualization=$(usex !datavis)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Location=$(usex !location)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Positioning=$(usex !positioning)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !quick yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=$(usex !scripttools)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Scxml=$(usex !scxml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sensors=$(usex !sensors)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5TextToSpeech=$(usex !speech)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngine=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineCore=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebSockets=$(usex !websockets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=$(usex !widgets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5X11Extras=$(usex !x11extras)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Xml=$(usex !xml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5XmlPatterns=$(usex !xmlpatterns)
	)

	pyside_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl pyside_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE
	python_foreach_impl virtx cmake-utils_src_test
}

src_install() {
	pyside_install() {
		cmake-utils_src_install
		mv "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl pyside_install
}
