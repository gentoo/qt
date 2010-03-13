# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-declarative/qt-declarative-4.6.0.ebuild,v 1.1 2009/12/26 20:49:17 ayoy Exp $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="debug demos examples"

DEPEND="~x11-libs/qt-core-${PV}
	~x11-libs/qt-gui-${PV}
	~x11-libs/qt-multimedia-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-webkit-${PV}
	~x11-libs/qt-xmlpatterns-${PV}"

RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/declarative
	src/plugins/qdeclarativemodules/
	tools/qml"
QT4_EXTRACT_DIRECTORIES="
	include/
	src/
	tools/"

src_configure() {
	myconf="${myconf} -declarative"
	qt4-build-edge_src_configure
}
