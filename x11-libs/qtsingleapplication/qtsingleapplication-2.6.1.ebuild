# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2 versionator

MY_P="${PN}-$(replace_version_separator 2 _)-opensource"

DESCRIPTION="Qt library to start applications only once per user"
HOMEPAGE="http://doc.qt.digia.com/solutions/4/qtsingleapplication/index.html"
SRC_URI="http://get.qt.nokia.com/qt/solutions/lgpl/${MY_P}.tar.gz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-gcc47.patch" )

src_configure() {
	eqmake4 CONFIG+=qtsingleapplication-uselib
}

src_install() {
	dolib.so lib/*
	doheader src/${PN}.h
}
