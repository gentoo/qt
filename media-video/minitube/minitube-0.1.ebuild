# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_PN="${PN}-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Qt4 YouTube Client"
HOMEPAGE="http://flavio.tordini.org/minitube"
SRC_URI="http://flavio.tordini.org/files/${PN}/${MY_P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4 x11-libs/qt-phonon:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin build/target/minitube || die "dobin failed"
	newicon images/app.png minitube.png || die "doicon failed"
	make_desktop_entry minitube MiniTube minitube.png "Qt;AudioVideo;Video" \
		|| die "make_desktop_entry failed"
}
