# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

LANGS="br ca cs da de es fr gl hu it ja ko nl pl ro ru sv"

inherit eutils qt4-r2 versionator subversion

MY_PN="xVST"
MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Download (and convert) videos from various Web Video Services"
HOMEPAGE="http://xviservicethief.sourceforge.net/"
ESVN_REPO_URI="http://xviservicethief.svn.sourceforge.net/svnroot/xviservicethief/trunk/"
# Note: all released versions are labelled alpha

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="app-arch/unzip
	dev-qt/qtgui:4"
RDEPEND="dev-qt/qtgui:4
	media-video/ffmpeg
	media-video/flvstreamer"

S=${WORKDIR}
TRANSLATIONSDIR=${S}/resources

src_prepare() {
	subversion_src_prepare

	# fix translations
	mv "${S}"/resources/translations/${MY_PN}_cz.ts \
		"${S}"/resources/translations/${MY_PN}_cs.ts || die
	mv "${S}"/resources/translations/${MY_PN}_jp.ts	\
		"${S}"/resources/translations/${MY_PN}_ja.ts || die
	mv "${S}"/resources/translations/${MY_PN}_du.ts	\
		"${S}"/resources/translations/${MY_PN}_nl.ts || die
	mv "${S}"/resources/translations/${MY_PN}_kr.ts	\
		"${S}"/resources/translations/${MY_PN}_ko.ts || die

	# fix plugins, language path
	sed -i -e "s/getApplicationPath()\ +\ \"/\"\/usr\/share\/${PN}/g" \
		"${S}"/src/options.cpp || die "failed to fix paths"

	qt4-r2_src_prepare
}

src_compile() {
	qt4-r2_src_compile

	local lang=
	for lang in "${S}"/resources/translations/*.ts; do
		lrelease ${lang}
	done
}

src_install() {
	dobin bin/xvst
	insinto /usr/share/pixmaps
	newins resources/images/InformationLogo.png xvst.png
	make_desktop_entry /usr/bin/xvst xVideoServiceThief xvst 'Qt;AudioVideo;Video'

	# install plugins
	local dest=/usr/share/${PN}/plugins
	dodir ${dest}
	find resources/services -name '*.js' -exec cp -dpR {} "${D}"${dest} \;

	qt4-r2_install_translations
}
