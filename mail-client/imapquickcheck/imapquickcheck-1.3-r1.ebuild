# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

LANGS="fr"

inherit eutils qt4-r2

MY_PN=ImapQuickCheck

DESCRIPTION="Lightweight systray IMAP mail checker"
HOMEPAGE="http://qt-apps.org/content/show.php/ImapQuickCheck?content=110821"
SRC_URI="http://qt-apps.org/CONTENT/content-files/110821-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]"
RDEPEND="${DEPEND}
	dev-lang/python[sqlite]"

src_prepare() {
	epatch "${FILESDIR}"/${P}-desktopfile.patch

	sed -i -e '/\.ts/d' ${MY_PN}.pro || die "sed failed"

	local ts
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			ts="${ts} ts/${PN}_${lingua}.ts"
		fi
	done

	if [[ -n ${ts} ]]; then
		echo "TRANSLATIONS = ${ts}" >> ${MY_PN}.pro || die "echo failed"
		lrelease ${MY_PN}.pro || die "Generating translations failed"
	fi
}

src_install() {
	dobin ${PN}
	dodoc README.txt
	domenu ${PN}.desktop

	local lingua
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			insinto "/usr/share/${PN}/translations"
			doins "ts/${PN}_${lingua}.ts" || "Installing translations failed"
		fi
	done
}
