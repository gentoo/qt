# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

DESCRIPTION="Qt4 tag editor for mp3 files"
HOMEPAGE="http://www.qt-apps.org/content/show.php/QTagConvert2?content=100481"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_install(){
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
