# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_REPO_URI="git://github.com/Voker57/qmpdclient-ne.git"

inherit qt4-edge git

DESCRIPTION="QMPDClient with NBL additions, such as lyrics' display"
HOMEPAGE="http://bitcheese.net/wiki/QMPDClient"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[dbus]"
RDEPEND="${DEPEND}"

LANGS="de_DE fr_FR it_IT nl_NL nn_NO no_NO pt_BR ru_RU sv_SE tr_TR uk_UA zh_CN zh_TW"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X%_*}"
done

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

src_compile() {
	emake || die "emake failed"
	emake translate || die "failed to generate translations"
}

src_install() {
	dodoc README AUTHORS THANKSTO Changelog || die "Installing docs failed"
	for res in 16 22 64 ; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins icons/qmpdclient${res}.png ${PN}.png || die "Installing icons failed"
	done

	dobin qmpdclient || die "Installing binary failed"
	make_desktop_entry qmpdclient "QMPDClient" ${PN} \
		"Qt;AudioVideo;Audio;" || die "Installing desktop entry failed"

	#install translations
	insinto /usr/share/QMPDClient/translations/
	local LANG=
	for LANG in ${LINGUAS};do
		for X in ${LANGS};do
			if [[ ${LANG} == ${X%_*} ]];then
				doins -r lang/${X}.qm || die "failed to install translations"
			fi
		done
	done
}
