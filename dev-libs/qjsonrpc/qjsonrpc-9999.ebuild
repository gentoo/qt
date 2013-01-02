# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="Qt-based library implementing the JSON-RPC 2.0 protocol"
HOMEPAGE="http://symbiosoft.net/projects/qjsonrpc"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}
	https://git.gitorious.org/${PN}/${PN}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug test"

DEPEND=">=x11-libs/qt-core-4.7:4"
RDEPEND="${DEPEND}"

src_prepare() {
	qt4-r2_src_prepare

	if ! use test; then
		sed -i -e '/SUBDIRS += tests/d' ${PN}.pro || die
	fi
}

src_install() {
	dolib.a lib/libqjsonrpc.a
	dodoc AUTHORS TODO
}
