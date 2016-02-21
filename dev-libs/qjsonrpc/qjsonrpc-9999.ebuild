# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib qt4-r2 git-2

DESCRIPTION="Qt implementation of the JSON-RPC 2.0 protocol"
HOMEPAGE="http://symbiosoft.net/projects/qjsonrpc"
EGIT_REPO_URI="https://bitbucket.org/devonit/qjsonrpc"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""
IUSE="debug test"

DEPEND=">=dev-qt/qtcore-4.7:4"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS CHANGES TODO)

src_prepare() {
	qt4-r2_src_prepare

	if ! use test; then
		sed -i -e 's/tests//' qjsonrpc.pro || die
	fi
}

src_configure() {
	eqmake4 LIBDIR="$(get_libdir)"
}
