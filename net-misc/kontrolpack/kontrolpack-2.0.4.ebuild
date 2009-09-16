# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="fr"

inherit qt4-edge

MY_PN="KontrolPack"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Remote shell command executor and LAN manager"
HOMEPAGE="http://www.kontrolpack.com"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

DEPEND=">=x11-libs/qt-gui-4.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e "s!\(${MY_PN}_\)!/usr/share/${PN}/locale/\1!" main/main.cpp \
		|| die "sed failed"
}

src_install() {
	dobin "${PN}" || die "installing binary failed"

	domenu "${PN}.desktop" || die "installing desktop file failed"
	doicon "${PN}.png" || die "installing icon file failed"

	for lingua in ${LINGUAS}; do
		if has ${lingua} ${LANGS}; then
			insinto /usr/share/${PN}/locale
			doins "lang/${MY_PN}_${lingua}.qm" || die "installing translations failed"
		fi
	done
}
