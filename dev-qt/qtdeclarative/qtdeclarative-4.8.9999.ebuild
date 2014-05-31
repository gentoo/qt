# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The Declarative module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
fi

IUSE="+accessibility qt3support webkit"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=]
	~dev-qt/qtgui-${PV}[accessibility=,aqua=,debug=,qt3support=]
	~dev-qt/qtopengl-${PV}[aqua=,debug=,qt3support=]
	~dev-qt/qtscript-${PV}[aqua=,debug=]
	~dev-qt/qtsql-${PV}[aqua=,debug=,qt3support=]
	~dev-qt/qtsvg-${PV}[accessibility=,aqua=,debug=]
	~dev-qt/qtxmlpatterns-${PV}[aqua=,debug=]
	qt3support? ( ~dev-qt/qt3support-${PV}[accessibility=,aqua=,debug=] )
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/declarative
	src/imports
	src/plugins/qmltooling
	tools/qml
	tools/qmlplugindump"

QT4_EXTRACT_DIRECTORIES="
	include
	src
	tools
	translations"

QCONFIG_ADD="declarative"
QCONFIG_DEFINE="QT_DECLARATIVE"

pkg_setup() {
	use webkit && QT4_TARGET_DIRECTORIES+="
		src/3rdparty/webkit/Source/WebKit/qt/declarative"
}

src_configure() {
	myconf+="
		-declarative -no-gtkstyle
		$(qt_use accessibility)
		$(qt_use qt3support)
		$(qt_use webkit)"
	qt4-build-multilib_src_configure
}
