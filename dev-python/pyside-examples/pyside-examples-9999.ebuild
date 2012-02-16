# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="Set of examples and demos for PySide"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/${PN%-*}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=""
RDEPEND=">=dev-python/pyside-0.2.2"

S="${WORKDIR}/${PN}"

src_install() {
	insinto "/usr/share/${PN%-*}"
	doins -r "examples"
}
