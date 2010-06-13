# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGSLONG="it_IT pl_PL"

inherit qt4-edge

MY_P=${PN}_${PV}

DESCRIPTION="GUI image conversion tool based on imagemagick"
HOMEPAGE="http://converseen.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	|| ( media-gfx/graphicsmagick[imagemagick] media-gfx/imagemagick )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-cflags.patch" )
DOCS="README"

src_prepare() {
	qt4-edge_src_prepare

	sed -i -e "s!/usr/lib!/usr/$(get_libdir)!" ${PN}.pro \
		|| die "sed libdir failed"

	local ts_files=
	for lingua in ${LINGUAS}; do
		for a in ${LANGSLONG}; do
			if [[ ${lingua} == ${a%_*} ]]; then
				ts_files="${ts_files} loc/${PN}_${a}.ts"
			fi
		done
	done
	local qm_files="${ts_files/.ts/.qm}"

	sed -e '/^ loc/d' \
		-e "s!\(TRANSLATIONS += \).*!\1${ts_files}!" \
		-e "s!\(translations\.files = \).*!\1${qm_files}!" \
		-i ${PN}.pro || die "sed translations failed"
}
