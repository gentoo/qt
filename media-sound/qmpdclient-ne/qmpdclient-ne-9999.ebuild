# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://github.com/Voker57/qmpdclient-ne.git"

inherit qt4-edge git

DESCRIPTION="QMPDClient with NBL additions, such as lyrics' display"
HOMEPAGE="http://github.com/Voker57/qmpdclient-ne/tree/master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[dbus]
	!>=media-sound/qmpdclient-1.1.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix the install path
	sed -i -e "s:PREFIX = /usr/local:PREFIX = /usr:" qmpdclient.pro \
		|| die "sed failed (install path)"

	# nostrip fix
	sed -i -e "s:CONFIG += :CONFIG += nostrip :" qmpdclient.pro \
		|| die "sed failed (nostrip)"

	sed -i -e "s:+= -O2 -g0 -s:+= -O2 -g0:" qmpdclient.pro \
		|| die "sed failed (nostrip)"
}

src_configure() {
	eqmake4 qmpdclient.pro
}

src_install() {
	dodoc README AUTHORS THANKSTO Changelog || die "Installing docs failed"
	for res in 16 22 64 ; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins icons/qmpdclient${res}.png ${PN}.png || die "Installing icons failed"
	done

	newbin qmpdclient qmpdclient-ne || die "Installing binary failed"
	make_desktop_entry qmpdclient-ne "QMPDClient-ne" ${PN} \
		"Qt;AudioVideo;Audio;" || die "Installing desktop entry failed"
}
