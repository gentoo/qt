# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qtwitter/qtwitter-0.8.3.ebuild,v 1.1 2009/08/08 17:42:03 hwoarang Exp $

EAPI="2"

inherit qt4

DESCRIPTION="A Qt-based client for Twitter and Identi.ca"
HOMEPAGE="http://www.qt-apps.org/content/show.php/qTwitter?content=99087"
SRC_URI="http://files.ayoy.net/qtwitter/release/${PV}/src/${P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +oauth"

DEPEND="x11-libs/qt-gui:4
	oauth? ( >=dev-libs/qoauth-1.0 )"
RDEPEND="${DEPEND}"

QTWITTER_LANGS="pt_BR"
QTWITTER_NOLONGLANGS="ca_ES cs_CZ de_DE es_ES fr_FR it_IT ja_JP pl_PL"

for L in $QTWITTER_LANGS; do
	IUSE="$IUSE linguas_$L"
done
for L in $QTWITTER_NOLONGLANGS; do
	IUSE="$IUSE linguas_${L%_*}"
done

src_prepare() {
	qt4_src_prepare
	echo "CONFIG += nostrip" >> "${S}"/${PN}.pro

	local langs=
	for lingua in $LINGUAS; do
		if has $lingua $QTWITTER_LANGS; then
			langs="$langs loc/${PN}_${lingua}.ts"
		else
			for a in $QTWITTER_NOLONGLANGS; do
				if [[ $lingua == ${a%_*} ]]; then
					langs="$langs loc/${PN}_${a}.ts"
				fi
			done
		fi
	done

	# remove translations and add only the selected ones
	sed -i -e '/^ *loc.*\.ts/d' \
	    -e "/^TRANSLATIONS/s:loc.*:${langs}:" \
	        qtwitter-app/qtwitter-app.pro || die "sed failed"
	# fix unsecure runpaths
	sed -i -e '/-Wl,-rpath,\$\${TOP}/d' \
	    qtwitter-app/qtwitter-app.pro || die "sed failed"

	sed -i "s!\(\$\${INSTALL_PREFIX}\)/lib!\1/$(get_libdir)!" \
		twitterapi/twitterapi.pro urlshortener/urlshortener.pro || die "sed failed"

	if ! use oauth; then
		sed -i '/DEFINES += OAUTH/d' ${PN}.pri || die "sed failed"
	fi
}

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README CHANGELOG || die "dodoc failed"
}
