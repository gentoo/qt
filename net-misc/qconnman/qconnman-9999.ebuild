# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="Qt4 Connman Applet"
HOMEPAGE="https://github.com/OSSystems/qconnman"
EGIT_REPO_URI="git://github.com/OSSystems/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/connman
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

DOCS="README.md"

src_configure() {
	eqmake4 ${PN}.pro PREFIX="/usr"
}
