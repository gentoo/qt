# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P="${P}.source"
MY_PN="Fritzing"
LANGS="ar bg cs de el en es et fr gl hi hu it ja ko nl pl ro ru sv th tr"
LANGSLONG="pt_BR pt_PT zh_CN zh_TW"

inherit eutils qt4-r2

DESCRIPTION="breadboard and arduino prototyping"
HOMEPAGE="http://fritzing.org/"
SRC_URI="http://fritzing.org/download/${PV}/source-tarball/${MY_P}.tar.bz2"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
	dev-libs/quazip
	>=x11-libs/qt-core-4.6:4
	>=x11-libs/qt-gui-4.6:4
	>=x11-libs/qt-sql-4.6:4
	>=x11-libs/qt-svg-4.6:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="README.txt"

src_prepare() {
	epatch "${FILESDIR}"/${P}-bundledlibs.patch

	# required for it to validate
	edos2unix ${PN}.desktop

	local alllangs="${LANGS} ${LANGSLONG}"
	local lang
	for lang in $alllangs; do
		if ! use linguas_${lang%_*} ; then
			lang="$(tr [:upper:] [:lower:] <<< "$lang")"
			rm translations/${PN}_${lang}.*
		fi
	done
}

src_configure() {
	eqmake4 phoenix.pro
}

src_install() {
	doman ${MY_PN}.1
	qt4-r2_src_install
}
