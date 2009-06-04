# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge
MY_PN="PictureWall"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Qt4 picture viewer and image searching tool using google.com"
HOMEPAGE="http://www.qt-apps.org/content/show.php?content=106101"
SRC_URI="http://picturewall.googlecode.com/files/PictureWall_1.0.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=x11-libs/qt-gui-4.5.1"
DEPEND="app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/${MY_PN}/${MY_PN}"

src_install(){
	dobin bin/${PN} || die "dobin failed"
	dodoc ReadMe || die "dodoc failed"
	dohtml -r doc/html/* || die "dohtml failed"
}
