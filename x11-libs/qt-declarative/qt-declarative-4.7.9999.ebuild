# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-declarative/qt-declarative-4.6.0.ebuild,v 1.1 2009/12/26 20:49:17 ayoy Exp $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[stable-branch=]
	~x11-libs/qt-gui-${PV}[stable-branch=]
	~x11-libs/qt-multimedia-${PV}[stable-branch=]
	~x11-libs/qt-script-${PV}[stable-branch=]
	~x11-libs/qt-sql-${PV}[stable-branch=]
	~x11-libs/qt-webkit-${PV}[stable-branch=]
	~x11-libs/qt-xmlpatterns-${PV}[stable-branch=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/declarative
		tools/qml"
	use stable-branch && QT4_TARGET_DIRECTORIES+=" src/plugins/qdeclarativemodules/"
	QT4_EXTRACT_DIRECTORIES="
		include/
		src/
		tools/"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -declarative"
	qt4-build-edge_src_configure
}
