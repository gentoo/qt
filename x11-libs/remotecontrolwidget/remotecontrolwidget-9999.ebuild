# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/qt-labs/remotecontrolwidget.git"
EGIT_BRANCH="simulator"

inherit qt4-r2 git

DESCRIPTION="Remote Control Widget for Qt-Simulator"
HOMEPAGE="http://qt.gitorious.org/qt-labs/remotecontrolwidget"
SRC_URI=""

LICENSE=""
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
