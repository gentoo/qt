# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="private-headers"

DEPEND="~x11-libs/qt-core-${PV}
	~x11-libs/qt-gui-${PV}
	~x11-libs/qt-multimedia-${PV}
	~x11-libs/qt-opengl-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-webkit-${PV}
	~x11-libs/qt-xmlpatterns-${PV}"
RDEPEND="${DEPEND}"

QCONFIG_ADD="declarative"

QT4_TARGET_DIRECTORIES="
	src/declarative
	tools/qml"
QT4_EXTRACT_DIRECTORIES="
	include/
	src/
	tools/"

src_configure() {
	myconf="${myconf} -declarative"
	qt4-build_src_configure
}

src_install() {
	qt4-build-edge_src_install
	if use private-headers; then
		insinto ${QTHEADERDIR}/QtDeclarative
		doins -r include/QtDeclarative/private \
			|| die "failed to install private headers"
	fi
}
