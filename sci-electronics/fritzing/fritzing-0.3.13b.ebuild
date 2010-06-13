# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="fritzing.2009.12.11.source"

inherit qt4

DESCRIPTION="breadboard and arduino prototyping"
HOMEPAGE="http://fritzing.org/"
SRC_URI="http://fritzing.org/download/${PV}/source-tarball/${MY_P}.tar.bz2"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4
	x11-libs/qt-svg:4
	x11-libs/qt-webkit:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure(){
	eqmake4 phoenix.pro || die "eqmake4 failed"
}

src_install(){
	dobin Fritzing || die "install failed"
}
