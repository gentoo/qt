# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
MY_P="CImg-${PV}"

inherit eutils base toolchain-funcs

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_install() {
	dodoc README.txt
	insinto /usr/include
	doins CImg.h
}
