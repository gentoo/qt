# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

LANGS="cs de en es fr he it ja lv nl pt pt_BR ru zh"
MY_P="${PN}-qt-${PV}"

inherit multilib qt4-r2

DESCRIPTION="A general purpose tile map editor."
HOMEPAGE="http://www.mapeditor.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="sys-libs/zlib
	>=x11-libs/qt-core-4.6:4
	>=x11-libs/qt-gui-4.6:4
	>=x11-libs/qt-opengl-4.6:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS COPYING NEWS README.md"

src_prepare() {
	rm -r src/zlib || die

	local lang languages
	for lang in ${LANGS} ; do
		if use linguas_${lang} ; then
			languages+=" ${lang}"
		fi
	done
	sed -e "s/^LANGUAGES =.*/LANGUAGES =${languages}/" -i translations/translations.pro || die
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
