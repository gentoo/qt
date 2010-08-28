# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib qt4-r2

MY_PN="Kognite"

DESCRIPTION="Platform independent document management software"
HOMEPAGE="http://code.google.com/p/kognite/"
SRC_URI="http://kognite.googlecode.com/files/${MY_PN}_source_${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="app-text/poppler[qt4]
	dev-libs/xapian
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

src_configure() {
	qmake -project -norecursive \
		INCPATH+=/usr/include/poppler/qt4 \
		LIBS+="-L/usr/$(get_libdir) -lxapian -lpoppler-qt4 -lz"
	eqmake4 ${MY_PN}.pro
}

src_install() {
	doicon kognite.png || die
	newbin Kognite kognite || die
	make_desktop_entry kognite Kognite kognite "System;FileTools"
}
