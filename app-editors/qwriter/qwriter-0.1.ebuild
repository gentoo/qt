# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

MY_P="${PN}-$(delete_all_version_separators)-src"

DESCRIPTION="Advanced text editor with syntax highlighting"
HOMEPAGE="http://qt-apps.org/content/show.php/QWriter?content=106377"
#upstream failed to provide a sane url
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[debug?]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	eqmake4
}

src_install() {
	dobin bin/${PN} || die "dobin failed"
	newicon images/w.png ${PN}.png || die "newicon failed"
	make_desktop_entry ${PN} QWriter ${PN}.png "Qt;TextTools" \
		die "make_desktop_entry failed"
}
