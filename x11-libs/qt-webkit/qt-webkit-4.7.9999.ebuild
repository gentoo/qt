# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The Webkit module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="kde"

DEPEND="~x11-libs/qt-core-${PV}[debug=,ssl,stable-branch=]
	~x11-libs/qt-dbus-${PV}[debug=,stable-branch=]
	~x11-libs/qt-gui-${PV}[dbus,debug=,stable-branch=]
	!kde? ( || ( ~x11-libs/qt-phonon-${PV}:${SLOT}[dbus,debug=,stable-branch=]
		media-sound/phonon ) )
	kde? ( media-sound/phonon )"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/3rdparty/webkit/WebCore tools/designer/src/plugins/qwebview"
QT4_EXTRACT_DIRECTORIES="
include/
src/
tools/"
QCONFIG_ADD="webkit"
QCONFIG_DEFINE="QT_WEBKIT"

src_prepare() {
	[[ $(tc-arch) == "ppc64" ]] && append-flags -mminimal-toc #241900
	if use sparc; then
		epatch "${FILESDIR}"/sparc-qt-webkit-sigbus.patch
	fi
	qt4-build-edge_src_prepare
}

src_configure() {
	myconf="${myconf} -webkit"
	qt4-build-edge_src_configure
}
