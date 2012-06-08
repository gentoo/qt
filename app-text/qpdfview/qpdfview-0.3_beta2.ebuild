# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/qpdfview/qpdfview-0.2.2.ebuild,v 1.1 2012/05/05 14:19:10 yngwin Exp $

EAPI=4
inherit qt4-r2

DESCRIPTION="A tabbed PDF viewer using the poppler library"
HOMEPAGE="http://launchpad.net/qpdfview"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV/_}/+download/${P/_}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/poppler[qt4]
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

DOCS="README TODO"

S=${WORKDIR}/${P/_}
