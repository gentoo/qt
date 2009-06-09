# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="de en_US zh_CN zh_TW"

inherit qt4-edge versionator

MY_PV=$(replace_version_separator 3 '-')
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Qt4 cross-platform multi-threaded download utility"
HOMEPAGE="http://qt-apps.org/content/show.php/?content=103312"
SRC_URI="http://netfleet.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=x11-libs/qt-gui-4.5.0:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

DOCS="readme.txt"

src_prepare(){
	# fix translations. Dont blame me plz
	sed -i "s/netFleet_de_DE.qm/${PN}_de.qm/" ${PN}.qrc
	mv translations/netFleet_de_DE.qm translations/${PN}_de.qm
	for x in ${LANGSLONG}; do
		sed -i "s/netFleet_${x}.qm/${PN}_${x}.qm/" ${PN}.qrc
		mv translations/netFleet_${x}.qm translations/${PN}_${x}.qm
	done
	qt4-edge_src_prepare
}
