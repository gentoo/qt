# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-webkit/qt-webkit-4.5.0.ebuild,v 1.4 2009/03/18 10:46:04 armin76 Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Webkit module for the Qt toolkit"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[debug=,ssl]
	~x11-libs/qt-gui-${PV}[debug=]
	|| ( ~x11-libs/qt-phonon-${PV}:${SLOT}[debug=] media-sound/phonon )"
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
	qt4-build_src_prepare
}

src_configure() {
	myconf="${myconf} -webkit"
	qt4-build_src_configure
}
