# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build

DESCRIPTION="The patternist module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[debug=]"
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

	qt4-build_pkg_setup
}

src_configure() {
	myconf="${myconf} -xmlpatterns"
	qt4-build_src_configure
}
