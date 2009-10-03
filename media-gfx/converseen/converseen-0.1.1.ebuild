# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_P=${PN}_${PV}

DESCRIPTION="GUI image conversion tool based on imagemagick"
HOMEPAGE="http://converseen.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	media-gfx/imagemagick[-nocxx]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-cflags.patch" )

src_prepare() {
	qt4-edge_src_prepare

	sed -i -e "s!/usr/lib!/usr/$(get_libdir)!" ${PN}.pro \
		|| die "sed libdir failed"
}
