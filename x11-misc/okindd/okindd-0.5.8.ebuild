# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_P="${P}-20090410"

DESCRIPTION="On Screen Display (OSD) for KDE 4.x - works on any qt desktop"
HOMEPAGE="http://sites.kochkin.org/okindd/Home"
SRC_URI="http://sites.kochkin.org/okindd/Home/source-code/${MY_P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-dbus:4"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/okindd_home_and_naming.patch" )

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i "s:okind/:okindd/:g" "${S}"/conf/okinddrc.example ||
		die "sed: fixing example paths failed"

	qt4_src_prepare
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	domenu "${S}"/okindd.desktop || die "domenu failed"

	elog "You can find an example configuration file at"
	elog "	/usr/share/doc/okindd/examples/okinddrc.example"
	elog "It should be placed in \${HOME}/.okindd/"
}
