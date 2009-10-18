# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="nb_NO pt_BR"
LANGSLONG="ca_ES cs_CZ de_DE es_ES fr_FR it_IT ja_JP pl_PL"

inherit qt4-edge git

DESCRIPTION="A Qt-based client for Twitter and Identi.ca"
HOMEPAGE="http://www.qt-apps.org/content/show.php/qTwitter?content=99087"
EGIT_REPO_URI="git://github.com/ayoy/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-gui-4.5:4
	>=x11-libs/qt-dbus-4.5:4
	>=dev-libs/qoauth-1.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	qt4-edge_src_prepare
	echo "CONFIG += nostrip" >> "${S}"/${PN}.pro

	local langs=
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			langs="$langs loc/${PN}_${lingua}.ts"
		else
			for a in $LANGSLONG; do
				if [[ $lingua == ${a%_*} ]]; then
					langs="$langs loc/${PN}_${a}.ts"
				fi
			done
		fi
	done

	# remove translations and add only the selected ones
	sed -i -e '/^ *loc.*\.ts/d' \
		-e "/^TRANSLATIONS/s:loc.*:${langs}:" \
			qtwitter-app/qtwitter-app.pro || die "sed translations failed"
	# fix insecure runpaths
	sed -i -e '/-Wl,-rpath,\$\${DESTDIR}/d' \
		qtwitter-app/qtwitter-app.pro || die "sed rpath failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README CHANGELOG || die "dodoc failed"
}
