# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4 eutils

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}-src-x11.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_ru"

S="${WORKDIR}/${P}-src"

RDEPEND=">=app-text/hunspell-1.2
	dev-libs/libzip
	media-libs/libogg
	media-libs/libvorbis
	x11-libs/libXtst
	>=x11-libs/qt-webkit-4.5:4"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc4.4.patch"
	# duplicates stuff into a directory we don't use
	sed -i \
		-e s/INSTALLS\ \+=\ desktops2//g \
		-e s/INSTALLS\ \+=\ icons2//g \
		"${S}"/goldendict.pro || die 'sed failed'
}

src_configure() {
	PREFIX=/usr eqmake4
}

src_compile() {
	if use linguas_ru ; then
		einfo 'Preparing translations...'
		lrelease ${PN}.pro || die 'lrelease failed'
	fi
	emake || die 'emake failed'
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die 'make install failed'
	if use linguas_ru ; then
		insinto /usr/share/apps/${PN}/locale
		doins locale/ru.qm || die 'doins failed'
	fi
}

pkg_postinst() {
	elog 'The portage tree contains various stardict and dictd dictionaries, which'
	elog 'GoldenDict can use. Also, check http://goldendict.berlios.de/dictionaries.php'
	elog 'for more options. The myspell packages can also be useful.'
}
