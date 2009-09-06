# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The patternist module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[debug=,exceptions]"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/xmlpatterns tools/xmlpatterns"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/QtCore
include/QtNetwork
include/QtXmlPatterns
src/network/
src/corelib/"

QCONFIG_ADD="xmlpatterns"
QCONFIG_DEFINE="QT_XMLPATTERNS"

src_configure() {
	myconf="${myconf} -xmlpatterns"
	qt4-build-edge_src_configure
}
