# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-edge

DESCRIPTION="Qt4 GUI for wine"
HOMEPAGE="http://sourceforge.net/projects/q4wine/"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]"
RDEPEND="${DEPEND}
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	>=media-gfx/icoutils-0.26.0"

S="${WORKDIR}/${PN}"

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README || die "dodoc failed"
	doicon src/data/wine16x16.png || die "doicon failed"
	make_desktop_entry q4wine Q4Wine wine16x16 "Utility" || die "make_desktop_entry failed"
}
