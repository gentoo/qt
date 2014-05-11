# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 subversion

MY_PN=MP3Diags

DESCRIPTION="Qt-based MP3 diagnosis and repair tool"
HOMEPAGE="http://mp3diags.sourceforge.net"
ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="
	>=dev-libs/boost-1.37:=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:4
"

S=${WORKDIR}/${PN}

src_prepare() {
	if use doc; then
		sed -i -e "s/QQQVERQQQ/${PV}/" src/Helpers.cpp || die
	fi
}

src_install() {
	dobin bin/${MY_PN}
	dodoc changelog.txt

	local size
	for size in 16 22 24 32 36 40 48; do
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		newins desktop/${MY_PN}${size}.png ${MY_PN}.png
	done
	domenu desktop/${MY_PN}.desktop

	use doc && dohtml doc/html/*
}
