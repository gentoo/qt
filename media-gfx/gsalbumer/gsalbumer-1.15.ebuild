# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_PN="GSalbumer"

DESCRIPTION="Qt4 simple photo archiving/album making tool"
HOMEPAGE="http://www.qt-apps.org/content/show.php/GSAlbumer?content=105158"
#Upstream provides same tarball name for every release
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${P}.tar.bz2"

LICENSE="GSoftware"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[debug?]"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

src_install(){
	newbin ${MY_PN} ${PN} || die "dobin failed"
}
