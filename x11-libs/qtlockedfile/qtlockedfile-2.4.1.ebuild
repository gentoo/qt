# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib qt4-r2 versionator

MY_P="${PN}-$(replace_version_separator 2 _)-opensource"

DESCRIPTION="QFile extension with advisory locking functions"
HOMEPAGE="http://doc.qt.digia.com/solutions/4/qtlockedfile/index.html"
SRC_URI="http://get.qt.nokia.com/qt/solutions/lgpl/${MY_P}.tar.gz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtcore:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-depend.patch"
	"${FILESDIR}/${P}-examples.patch"
)

src_configure() {
	eqmake4 CONFIG+=qtlockedfile-uselib
}

src_install() {
	dolib.so lib/*
	doheader src/${PN}.h
}
