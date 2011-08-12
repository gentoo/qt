# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build

DESCRIPTION="The Webkit module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="dbus kde"

DEPEND="~x11-libs/qt-core-${PV}[debug=,ssl]
	~x11-libs/qt-gui-${PV}[dbus?,debug=]
	~x11-libs/qt-xmlpatterns-${PV}[debug=]
	~x11-libs/qt-xmlpatterns-${PV}[debug=]
	dbus? ( ~x11-libs/qt-dbus-${PV}[debug=] )
	!kde? ( || ( ~x11-libs/qt-phonon-${PV}:${SLOT}[dbus=,debug=]
		media-libs/phonon ) )
	kde? ( media-libs/phonon )"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/3rdparty/webkit/Source/JavaScriptCore/
		src/3rdparty/webkit/Source/WebCore/
		src/3rdparty/webkit/Source/WebKit/qt/
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
	# drop qt_webkit_version.pri from installation files since qt-core
	# installs it
	qt4-build_src_prepare
}

src_configure() {
	myconf="${myconf} -webkit $(qt_use dbus qdbus) -no-gtkstyle"
	qt4-build_src_configure
}
