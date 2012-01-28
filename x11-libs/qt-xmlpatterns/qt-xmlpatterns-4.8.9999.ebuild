# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-xmlpatterns/qt-xmlpatterns-4.7.4.ebuild,v 1.1 2011/09/08 09:23:04 wired Exp $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The patternist module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
	KEYWORDS=""
fi
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=,exceptions]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="src/xmlpatterns tools/xmlpatterns"
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
			include/QtCore
			include/QtNetwork
			include/QtXml
			include/QtXmlPatterns
			src/network/
			src/xml/
			src/corelib/"
	fi

	QCONFIG_ADD="xmlpatterns"
	QCONFIG_DEFINE="QT_XMLPATTERNS"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -xmlpatterns"
	qt4-build-edge_src_configure
}
