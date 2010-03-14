# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="pt_BR"
lANGSLONG="ru_RU"
inherit qt4-edge git

DESCRIPTION="QtWebkit browser focusing on usability"
HOMEPAGE="http://qt-apps.org/content/show.php/Surfer?content=110535"
EGIT_REPO_URI="git://gitorious.org/surfer/surfer.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/qt-webkit-4.6.0"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s/QApplication::applicationDirPath() + \"/\"\/usr\/share\/surfer/" \
		src/application.cpp || die "failed to fix translations path"
	qt4-edge_src_prepare
}

src_configure() {
	qt4-edge_src_configure
	lrelease ${PN}.pro
}

src_install() {
	dobin bin/${PN} || die "dobin failed"
	prepare_translations
	domenu ${PN}.desktop || die "domenu failed"
}
