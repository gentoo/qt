# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-declarative/qt-declarative-4.6.0.ebuild,v 1.1 2009/12/26 20:49:17 ayoy Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}
	~x11-libs/qt-gui-${PV}
	~x11-libs/qt-multimedia-${PV}
	~x11-libs/qt-opengl-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-webkit-${PV}
	~x11-libs/qt-xmlpatterns-${PV}"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/declarative
		tools/qml"
	QT4_EXTRACT_DIRECTORIES="
		include/
		src/
		tools/"

	qt4-build_pkg_setup
}

src_configure() {
	myconf="${myconf} -declarative"
	qt4-build_src_configure
}
