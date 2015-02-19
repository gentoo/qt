# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2

MY_PN="QGRUBEditor"
MY_P="${MY_PN}"-"${PV}"

DESCRIPTION="QGRUBEditor is a system tool to view and edit the GRUB boot loader"
HOMEPAGE="http://qt-apps.org/content/show.php/QGRUBEditor?content=60391"
SRC_URI="http://qt-apps.org/CONTENT/content-files/60391-${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="app-arch/gzip
	media-gfx/imagemagick
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	|| ( sys-boot/grub sys-boot/grub-static )"

S="${WORKDIR}/${MY_PN}"

PATCHES=( "${FILESDIR}/${P}-gcc-4.7.patch" )
DOCS=( AUTHORS README ChangeLog )
