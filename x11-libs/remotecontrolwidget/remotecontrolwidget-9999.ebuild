# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/qt-labs/${PN}"
EGIT_BRANCH="simulator"

inherit qt4-r2 git-2

DESCRIPTION="Remote Control Widget for Qt-Simulator"
HOMEPAGE="http://qt.gitorious.org/qt-labs/remotecontrolwidget"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s#\$\$PREFIX#/usr#" -i library/${PN}.pro || die "sed failed"
}

src_configure() {
	eqmake4 library/${PN}.pro
}
