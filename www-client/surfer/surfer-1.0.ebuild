# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="pt_BR"
LANGSLONG="ru_RU"
inherit qt4-r2

DESCRIPTION="QtWebkit browser focusing on usability"
HOMEPAGE="http://qt-apps.org/content/show.php/Surfer?content=110535"
SRC_URI="http://qt-apps.org/CONTENT/content-files/110535-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/qt-webkit-4.6.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PN}"

src_prepare() {
	epatch "${FILESDIR}"/fix_ptr_to_int_cast.patch
	sed -i "s/QApplication::applicationDirPath() + \"/\"\/usr\/share\/surfer/" \
		src/application.cpp || die "failed to fix translations path"
	qt4-r2_src_prepare
}

src_configure() {
	qt4-r2_src_configure
	lrelease ${PN}.pro
}

src_install() {
	dobin bin/${PN} || die "dobin failed"
	make_desktop_entry ${PN} Surfer applications-internet "Qt;Network;WebBrowser"
	#install translations
	insinto /usr/share/${PN}/translations/
	for x in ${LINGUAS}; do
		for z in ${LANGS}; do
			[[ ${x} == ${z} ]] && doins translations/${z}.qm
		done
		for y in ${LANGSLONG}; do
			[[ ${x} == ${y%_*} ]] && doins translations/${y}.qm
		done
	done
}
