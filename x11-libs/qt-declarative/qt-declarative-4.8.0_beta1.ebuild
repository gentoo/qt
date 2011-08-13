# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="private-headers qt3support webkit"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,qt3support=]
    ~x11-libs/qt-gui-${PV}[aqua=,qt3support=]
    ~x11-libs/qt-opengl-${PV}[aqua=,qt3support=]
    ~x11-libs/qt-script-${PV}[aqua=]
    ~x11-libs/qt-sql-${PV}[aqua=,qt3support=]
    ~x11-libs/qt-svg-${PV}[aqua=]
    ~x11-libs/qt-xmlpatterns-${PV}[aqua=]
    qt3support? ( ~x11-libs/qt-qt3support-${PV}[aqua=] )
    webkit? ( ~x11-libs/qt-webkit-${PV}[aqua=] )"

RDEPEND="${DEPEND}"

pkg_setup() {
	QCONFIG_ADD="declarative"

	QT4_TARGET_DIRECTORIES="
		src/declarative
		src/imports
		tools/designer/src/plugins/qdeclarativeview
		tools/qml"

	if use webkit; then
		QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
			src/3rdparty/webkit/WebKit/qt/declarative"
	fi

	QT4_EXTRACT_DIRECTORIES="
		include/
		src/
		tools/
		translations/"

	qt4-build_pkg_setup
}


src_configure() {
	myconf="${myconf} -declarative -no-gtkstyle"
	qt4-build_src_configure
}

src_install() {
	qt4-build_src_install
	if use private-headers; then
		insinto ${QTHEADERDIR}/QtDeclarative/private
		find "${S}"/src/declarative/ -type f -name "*_p.h" -exec doins {} \;
	fi
}
