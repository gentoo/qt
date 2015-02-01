# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PLOCALES="cs de en es fr he it ja lv nl pt pt_BR ru zh"
MY_P="${PN}-qt-${PV}"

inherit multilib l10n qt4-r2 git-2

DESCRIPTION="A general purpose tile map editor."
HOMEPAGE="http://www.mapeditor.org/"
EGIT_REPO_URI="git://github.com/bjorn/${PN}.git"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND="sys-libs/zlib
	>=dev-qt/qtcore-4.6:4
	>=dev-qt/qtgui-4.6:4
	>=dev-qt/qtopengl-4.6:4"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS COPYING NEWS README.md )

src_prepare() {
	rm -r src/zlib || die
	sed -e "s/^LANGUAGES =.*/LANGUAGES = $(l10n_get_locales)/" \
		-i translations/translations.pro || die
}

src_configure() {
	eqmake4 LIBDIR="/usr/$(get_libdir)" PREFIX="/usr"
}

src_install() {
	qt4-r2_src_install

	if use examples ; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
