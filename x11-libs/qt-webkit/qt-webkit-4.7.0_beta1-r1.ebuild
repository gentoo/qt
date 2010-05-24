# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Webkit module for the Qt toolkit"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="dbus kde"

DEPEND="~x11-libs/qt-core-${PV}[debug=,ssl]
	~x11-libs/qt-gui-${PV}[dbus?,debug=]
	~x11-libs/qt-multimedia-${PV}[debug=]
	~x11-libs/qt-xmlpatterns-${PV}[debug=]
	dbus? ( ~x11-libs/qt-dbus-${PV}[debug=] )
	!kde? ( || ( ~x11-libs/qt-phonon-${PV}:${SLOT}[dbus=,debug=]
		media-sound/phonon ) )
	kde? ( media-sound/phonon )"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/3rdparty/webkit/JavaScriptCore
		src/3rdparty/webkit/WebCore
		tools/designer/src/plugins/qwebview"
	QT4_EXTRACT_DIRECTORIES="
		include/
		src/
		tools/"

	QCONFIG_ADD="webkit"
	QCONFIG_DEFINE="QT_WEBKIT"

	qt4-build_pkg_setup
}

src_prepare() {
	[[ $(tc-arch) == "ppc64" ]] && append-flags -mminimal-toc #241900

	qt4-build_src_prepare
}

src_configure() {
	myconf="${myconf} -webkit $(qt_use dbus qdbus)"
	qt4-build_src_configure
}
