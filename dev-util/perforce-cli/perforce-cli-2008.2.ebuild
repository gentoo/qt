# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="CLI Tools for a commercial version control system"
HOMEPAGE="http://www.perforce.com/"
BASE_URI="http://www.perforce.com/downloads/perforce/r08.2"
SRC_URI="
	amd64? ( ${BASE_URI}/bin.linux26x86_64/p4 -> p4-x86_64-${PV} )
	x86? ( ${BASE_URI}/bin.linux26x86/p4 -> p4-x86-${PV} )"

LICENSE="|| ( perforce-commercial.pdf perforce-open_source.pdf )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"
DEPEND="virtual/libc"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack(){
	if use amd64;then
		MY_P="p4-x86_64-${PV}"
	else
		MY_P="p4-x86-${PV}"
	fi
	cp "${DISTDIR}/${MY_P}" "${WORKDIR}"
}

src_install() {
	newbin ${MY_P} p4 || die "newbin failed"
}
