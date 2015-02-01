# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

LANGS="nb_NO pt_BR"
LANGSLONG="ca_ES cs_CZ de_DE es_ES fr_FR it_IT ja_JP pl_PL"

inherit qt4-r2 git-2

DESCRIPTION="A Qt-based microblogging client"
HOMEPAGE="http://www.qt-apps.org/content/show.php/qTwitter?content=99087"
EGIT_REPO_URI="git://github.com/ayoy/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=dev-libs/qoauth-1.0
	x11-libs/libX11
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtdbus-4.5:4
	>=dev-qt/qtgui-4.5:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

DOCS="README CHANGELOG"

src_prepare() {
	qt4-r2_src_prepare
	echo "CONFIG += nostrip" >> "${S}"/${PN}.pro

	local langs=
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			langs="$langs ${lingua}"
		else
			for a in $LANGSLONG; do
				if [[ $lingua == ${a%_*} ]]; then
					langs="$langs ${a}"
				fi
			done
		fi
	done

	# remove translations and add only the selected ones
	sed -e '/^ *LANGS/,/^$/s/^/#/' \
		-e "/LANGS =/s/.*/LANGS = ${langs}/" \
		-i translations/translations.pri || die "sed translations failed"
}

src_configure() {
	eqmake4 PREFIX="/usr"
}
