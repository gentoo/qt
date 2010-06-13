# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="fr"

inherit qt4-edge subversion

MY_PN="KontrolPack"

DESCRIPTION="Remote shell command executor and LAN manager"
HOMEPAGE="http://www.kontrolpack.com"
ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-gui-4.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

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
			doins "langs/${MY_PN}_${lingua}.qm" || die "installing translations failed"
		fi
	done
}
