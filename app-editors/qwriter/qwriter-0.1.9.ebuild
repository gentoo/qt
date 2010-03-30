# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

MY_P="${P}-src"

DESCRIPTION="Advanced text editor with syntax highlighting"
HOMEPAGE="http://qt-apps.org/content/show.php/QWriter?content=106377"
#upstream failed to provide a sane url
SRC_URI="http://qwriter.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_install() {
	dobin bin/${PN} || die "dobin failed"
	newicon images/w.png ${PN}.png || die "newicon failed"
	make_desktop_entry ${PN} QWriter ${PN} "Qt;TextTools" \
		die "make_desktop_entry failed"
}
