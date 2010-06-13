# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils qt4-edge

MY_P="${P/-/_}"
DESCRIPTION="BSCommander is a Qt based file manager"
HOMEPAGE="http://www.beesoft.org/index.php?id=bsc"
SRC_URI="http://www.beesoft.org/download/${MY_P}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i -e "/^CFLAGS.*/s:-pipe -O2:${CFLAGS}:" \
		-e "/^CXXFLAGS.*/s:-pipe -fpermissive -O3:${CXXFLAGS}:" \
		Makefile || die "sed failed on Makefile"
	sed -i -e "/^QMAKE_CXXFLAGS_RELEASE.*/s:-O3:${CXXFLAGS}:" \
		${PN}.pro || die "sed failed on ${PN}.pro"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins help.en.html

	newicon BeesoftCommander.png ${PN}.png
	make_desktop_entry ${PN} BSCommander ${PN} "FileManager;Utility;Qt"
}
