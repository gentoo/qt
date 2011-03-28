# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_REPO_URI="git://gitorious.org/goldendict/goldendict.git"
LANGSLONG="ar_SA bg_BG cs_CZ de_DE el_GR lt_LT ru_RU zh_CN"

inherit git qt4-r2

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.berlios.de/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug kde"

RDEPEND=">=app-text/hunspell-1.2
	media-libs/libogg
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libXtst
	>=x11-libs/qt-core-4.5:4[exceptions]
	>=x11-libs/qt-gui-4.5:4[exceptions]
	>=x11-libs/qt-webkit-4.5:4[exceptions]
	!kde? ( || (
		>=x11-libs/qt-phonon-4.5:4[exceptions]
		media-libs/phonon
	) )
	kde? ( media-libs/phonon )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	S=${WORKDIR}/${P} git_src_unpack
}

src_prepare() {
	qt4-r2_src_prepare

	# don't install duplicated stuff and fix installation path
	sed -i \
		-e '/desktops2/d' \
		-e '/icons2/d' \
		-e '/PREFIX = /s:/usr/local:/usr:' \
		${PN}.pro || die

	# add trailing semicolon
	sed -i -e '/^Categories/s/$/;/' redist/${PN}.desktop || die
}

src_install() {
	qt4-r2_src_install

	# install translations
	insinto /usr/share/apps/${PN}/locale
	for lang in ${LANGSLONG}; do
		if use linguas_${lang%_*}; then
			doins locale/${lang}.qm || die
		fi
	done
}
