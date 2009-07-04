# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xvideoservicethief/xvideoservicethief-2.0.0-r1.ebuild,v 1.3 2009/06/08 23:46:05 mr_bones_ Exp $

EAPI=2
inherit eutils qt4 versionator

MY_PN=xVST
MY_PV=$(replace_all_version_separators '_')
MY_P=${MY_PN}_${MY_PV}_src

DESCRIPTION="Download (and convert) videos from various Web Video Services"
HOMEPAGE="http://xviservicethief.sourceforge.net/"
SRC_URI="mirror://sourceforge/xviservicethief/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug linguas_br linguas_ca linguas_cs linguas_da linguas_de linguas_es
linguas_fr linguas_gl linguas_hu linguas_it linguas_pl linguas_ro
linguas_sv"

DEPEND="app-arch/unzip
	>=x11-libs/qt-gui-4.5.0:4"
RDEPEND=">=x11-libs/qt-gui-4.5.0:4
	media-video/ffmpeg"

S="${WORKDIR}/${MY_PN}-src-1.2"

LANGS="br ca cs da de es fr gl hu it pl ro sv"

src_prepare() {
	# fix checz translation
	mv "${S}"/resources/translations/xVST_cz.ts	"${S}"/resources/translations/xVST_cs.ts
	# fix plugins, language path
	sed -i -e "s/getApplicationPath()\ +\ \"/\"\/usr\/share\/${PN}/g" \
		"${S}"/src/options.cpp || die "failed to fix paths"
}

src_configure() {
	eqmake4 xVideoServiceThief.pro
}

src_compile() {
	local lang=
	emake || die "emake failed"
	for lang in "${S}"/resources/translations/*.ts; do
		lrelease ${lang}
	done
}

src_install() {
	dobin bin/xvst || die "dobin failed"
	local dest=/usr/share/${PN}/plugins
	dodir ${dest}
	find resources/services -name '*.js' -exec cp -dpR {} "${D}"${dest} \;
	dodoc changelog.txt
	newicon resources/images/InformationLogo.png xvst.png
	make_desktop_entry /usr/bin/xvst xVideoServiceThief xvst 'Qt;AudioVideo;Video'

	#install translations
	insinto /usr/share/${PN}/languages/
	local lang= tlang=
	for lang in ${LINGUAS}; do
		for tlang in ${LANGS}; do
			[[ ${lang} == ${tlang} ]] && doins "${S}"/resources/translations/xVST_${tlang}.qm
		done
	done
}
