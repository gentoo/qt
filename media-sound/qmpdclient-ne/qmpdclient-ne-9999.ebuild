# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qmpdclient/qmpdclient-1.0.9.ebuild,v 1.6 2008/07/28 16:06:31 gentoofan23 Exp $

EAPI="2"

EGIT_REPO_URI="git://github.com/Voker57/qmpdclient-ne.git"

inherit qt4 git

DESCRIPTION="QMPDClient with NBL additions, such as lyrics' display"
HOMEPAGE="http://github.com/Voker57/qmpdclient-ne/tree/master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[dbus]"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack

	# Fix the install path
	sed -i -e "s:PREFIX = /usr/local:PREFIX = /usr:" qmpdclient.pro \
		|| die "sed failed (install path)"
	
	# nostrip fix
	sed -i -e "s:CONFIG += :CONFIG += nostrip :" qmpdclient.pro \
		|| die "sed failed (nostrip)"

	sed -i -e "s:+= -O2 -g0 -s:+= -O2 -g0:" qmpdclient.pro \
	        || die "sed failed (nostrip)"
}

src_compile() {
	eqmake4 qmpdclient.pro || die "qmake failed"
	emake || die "make failed"
}

src_install() {
	dodoc README AUTHORS THANKSTO Changelog || die "dodoc failed"
	for res in 16 22 64 ; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/ || die "insinto failed"
		newins icons/qmpdclient${res}.png ${PN}.png || die "newins failed"
	done

	newbin qmpdclient qmpdclient-ne || die "newbin failed"
	make_desktop_entry qmpdclient-ne "QMPDClient-ne" ${PN} "Qt;AudioVideo;Audio;" || die "make_desktop_entry failed"
}
