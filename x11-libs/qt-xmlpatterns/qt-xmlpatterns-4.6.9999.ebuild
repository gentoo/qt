# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The patternist module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[debug=,kde-qt=,stable-branch=]"
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

src_prepare() {
	qt4-build-edge_src_prepare
	if use stable-branch || use kde-qt; then
		epatch "${FILESDIR}"/qt-4.6-nolibx11.diff
	else
		epatch "${FILESDIR}"/qt-4.6-master-nolibx11.patch
	fi
}

src_configure() {
	myconf="${myconf} -xmlpatterns"
	qt4-build-edge_src_configure
}
