# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
LANGS="el es_AR es_ES"
inherit qt4-r2

DESCRIPTION="Fast and lightweight Qt4 image viewer"
HOMEPAGE="http://code.google.com/p/qiviewer/"
SRC_URI="http://qiviewer.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="webp"

DEPEND="x11-libs/qt-gui:4
	webp? ( media-libs/libwebp )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	local _webp=
	use webp && _webp="CONFIG+=enable-webp"
	eqmake4 src/${PN}.pro $_webp
}
