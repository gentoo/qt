# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-xmlpatterns/qt-xmlpatterns-4.7.4.ebuild,v 1.1 2011/09/08 09:23:04 wired Exp $

EAPI="3"
inherit qt4-build

DESCRIPTION="The patternist module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[aqua=,debug=,exceptions]"
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
