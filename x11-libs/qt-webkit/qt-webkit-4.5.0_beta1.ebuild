# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils qt4-build-edge flag-o-matic toolchain-funcs

DESCRIPTION="The Webkit module for the Qt toolkit."
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~x11-libs/qt-core-${PV}[ssl]
	~x11-libs/qt-gui-${PV}"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/3rdparty/webkit/WebCore tools/designer/src/plugins/qwebview"
QT4_EXTRACT_DIRECTORIES="
include/
src/
tools/"
QCONFIG_ADD="webkit"
QCONFIG_DEFINE="QT_WEBKIT"

src_unpack() {
	[[ $(tc-arch) == "ppc64" ]] && append-flags -mminimal-toc #241900

	qt4-build-edge_src_unpack
	epatch "${FILESDIR}"/ExecutableAllocator_h.patch
}

src_configure() {
	myconf="${myconf} -webkit"
	qt4-build-edge_src_configure
}
