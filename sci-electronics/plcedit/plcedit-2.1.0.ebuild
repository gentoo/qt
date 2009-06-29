# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator qt4

MY_PN="PLCEdit"
MY_PV="$(delete_all_version_separators)"
MY_P="${MY_PN}_${MY_PV}_r43_svn"

DESCRIPTION="Qt4 notepad for PLC programming"
HOMEPAGE="http://www.qt-apps.org/content/show.php/PLCEdit?content=78380"
#upstreams default tarball is quite messy. Better repack it myself :/
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="x11-libs/qt-gui:4[debug?]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_configure(){
	eqmake4 ${MY_PN}.pro
}

src_install(){
	dobin release/${MY_PN} || die "dobin failed"
	newicon src/ressources/images/icon.png ${PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN} ${PN}.png 'Qt;Electronics'
	dodoc readme.txt || die "dodoc failed"
	if use doc; then
		dohtml -r Docs/html/* || die "dohtml failed"
	fi
}
