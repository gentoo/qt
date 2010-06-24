# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The patternist module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[debug=,exceptions,stable-branch=]"
RDEPEND="${DEPEND}"


pkg_setup() {
	QT4_TARGET_DIRECTORIES="src/xmlpatterns tools/xmlpatterns"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/QtCore
		include/QtNetwork
		include/QtXml
		include/QtXmlPatterns
		src/network/
		src/xml/
		src/corelib/"

	QCONFIG_ADD="xmlpatterns"
	QCONFIG_DEFINE="QT_XMLPATTERNS"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -xmlpatterns"
	qt4-build-edge_src_configure
}
