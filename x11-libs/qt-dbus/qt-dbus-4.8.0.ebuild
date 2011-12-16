# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-dbus/qt-dbus-4.7.4.ebuild,v 1.1 2011/09/08 09:19:13 wired Exp $

EAPI="3"
inherit qt4-build

DESCRIPTION="The DBus module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[aqua=,debug=]
	>=sys-apps/dbus-1.0.2"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/dbus
		tools/qdbus/qdbus
		tools/qdbus/qdbusxml2cpp
		tools/qdbus/qdbuscpp2xml"
	QCONFIG_ADD="dbus dbus-linked"
	QCONFIG_DEFINE="QT_DBUS"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/QtCore
		include/QtDBus
		include/QtXml
		src/corelib
		src/xml"

	qt4-build_pkg_setup
}

src_configure() {
	myconf="${myconf} -dbus-linked"
	qt4-build_src_configure
}
