# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="private-headers qt3support webkit"

DEPEND="~x11-libs/qt-core-${PV}[stable-branch=,qt3support=]
	~x11-libs/qt-gui-${PV}[stable-branch=,qt3support=]
	~x11-libs/qt-multimedia-${PV}[stable-branch=]
	~x11-libs/qt-opengl-${PV}[stable-branch=,qt3support=]
	~x11-libs/qt-script-${PV}[stable-branch=]
	~x11-libs/qt-sql-${PV}[stable-branch=,qt3support=]
	~x11-libs/qt-svg-${PV}[stable-branch=]	
	~x11-libs/qt-webkit-${PV}[stable-branch=]
	~x11-libs/qt-xmlpatterns-${PV}[stable-branch=]
	qt3support? ( ~x11-libs/qt-qt3support-${PV}[stable-branch=] )
	webkit? ( ~x11-libs/qt-webkit-${PV}[stable-branch=] )"
RDEPEND="${DEPEND}"

QCONFIG_ADD="declarative"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/declarative
		tools/qml"
	QT4_EXTRACT_DIRECTORIES="
		include/
		src/
		tools/"
		if use webkit; then
			QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
			src/3rdparty/webkit/WebKit/qt/declarative"
		fi
	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -declarative"
	qt4-build-edge_src_configure
}

src_install() {
	qt4-build-edge_src_install
	if use private-headers; then
		insinto ${QTHEADERDIR}/QtDeclarative/private
		find "${S}"/src/declarative/ -type f -name "*_p.h" -exec doins {} \;
	fi
}
