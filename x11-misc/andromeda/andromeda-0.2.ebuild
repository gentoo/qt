# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Qt4-based filemanager"
HOMEPAGE="https://gitorious.org/andromeda/pages/Home"
SRC_URI="https://gitorious.org/${PN}/${PN}/archive-tarball/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=x11-libs/qt-core-4.7.0:4
	>=x11-libs/qt-gui-4.7.0:4
	>=x11-libs/qt-webkit-4.7.0:4"
RDEPEND="${DEPEND}"
DOCS="TODO.txt dist/changes-${PV}"

src_unpack() {
	default
	mv ${PN}-${PN} "${S}" || die
}
