# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2

DESCRIPTION="Simple battery state program"
HOMEPAGE="http://code.google.com/p/batterymeter/"
SRC_URI="http://batterymeter.googlecode.com/files/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/libacpi
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}/src
