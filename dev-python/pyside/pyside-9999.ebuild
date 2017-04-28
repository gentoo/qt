# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils flag-o-matic python-r1 virtualx git-r3

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"
EGIT_REPO_URI=(
	"git://code.qt.io/pyside/pyside.git"
	"https://code.qt.io/git/pyside/pyside.git"
)

#FIXME: Switch to the clang-enabled "dev" branch once stable.
EGIT_BRANCH="5.6"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""

IUSE="
	concurrent declarative designer gui help multimedia network opengl
	printsupport script scripttools sql svg test testlib webchannel webengine
	webkit websockets widgets x11extras xmlpatterns"

# The requirements below were strongly inspired by their "PyQt5" equivalents.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( gui network )
	designer? ( widgets )
	help? ( widgets )
	multimedia? ( gui network )
	opengl? ( widgets )
	printsupport? ( widgets )
	scripttools? ( gui script )
	sql? ( widgets )
	svg? ( widgets )
	test? ( widgets )
	testlib? ( widgets )
	webchannel? ( network )
	webengine? ( network webchannel widgets )
	webkit? ( gui network printsupport widgets )
	websockets? ( network )
	widgets? ( gui )
	xmlpatterns? ( network )
"

# Minimum version of Qt required, derived from the "CMakeLists.txt" line:
#      find_package(Qt5 ${QT_PV} REQUIRED COMPONENTS Core)
QT_PV=":5/5.6"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-qt/qtcore${QT_PV}
	dev-qt/qtxml${QT_PV}
	declarative? ( dev-qt/qtdeclarative${QT_PV}[widgets?] )
	designer? ( dev-qt/designer${QT_PV} )
	help? ( dev-qt/qthelp${QT_PV} )
	multimedia? ( dev-qt/qtmultimedia${QT_PV}[widgets?] )
	opengl? ( dev-qt/qtopengl${QT_PV} )
	printsupport? ( dev-qt/qtprintsupport${QT_PV} )
	script? ( dev-qt/qtscript${QT_PV} )
	sql? ( dev-qt/qtsql${QT_PV} )
	svg? ( dev-qt/qtsvg${QT_PV} )
	testlib? ( dev-qt/qttest${QT_PV} )
	webchannel? ( dev-qt/qtwebchannel${QT_PV} )
	webengine? ( dev-qt/qtwebengine${QT_PV}[widgets?] )
	webkit? ( dev-qt/qtwebkit${QT_PV}[printsupport] )
	websockets? ( dev-qt/qtwebsockets${QT_PV} )
	x11extras? ( dev-qt/qtx11extras${QT_PV} )
	xmlpatterns? ( dev-qt/qtxmlpatterns${QT_PV} )
	concurrent? ( dev-qt/qtconcurrent${QT_PV} )
	gui? ( dev-qt/qtgui${QT_PV} )
	network? ( dev-qt/qtnetwork${QT_PV} )
	printsupport? ( dev-qt/qtprintsupport${QT_PV} )
	sql? ( dev-qt/qtsql${QT_PV} )
	testlib? ( dev-qt/qttest${QT_PV} )
	widgets? ( dev-qt/qtwidgets${QT_PV} )
"
DEPEND="${RDEPEND}"

src_prepare() {
	#FIXME: Remove the following "sed" patch after this upstream issue is closed:
	#    https://bugreports.qt.io/browse/PYSIDE-502
	
	# Force the optional "Qt5Concurrent", "Qt5Gui", "Qt5Network",
	# "Qt5PrintSupport", "Qt5Sql", "Qt5Test", and "Qt5Widgets" packages
	# erroneously marked as mandatory to be optional.
	sed -i -e 's/^\(CHECK_PACKAGE_FOUND(Qt5\(Concurrent\|Gui\|Network\|PrintSupport\|Sql\|Test\|Widgets\)\))$/\1 opt)/' \
		PySide2/CMakeLists.txt || die

	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# For each line of the form "CHECK_PACKAGE_FOUND(${PACKAGE_NAME} opt)" in
	# "PySide2/CMakeLists.txt" defining an optional dependency, an option of the
	# form "-DCMAKE_DISABLE_FIND_PACKAGE_${PACKAGE_NAME}=$(usex !${USE_FLAG})"
	# is passed to "cmake" here conditionally disabling this dependency.
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5OpenGL=$(usex !opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=$(usex !scripttools)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngine=$(usex !webengine)
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
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
