# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="Search, watch, and download stuff from Google Images and YouTube"
HOMEPAGE="http://sourceforge.net/projects/googleimagedown/"
SRC_URI="mirror://sourceforge/googleimagedown/${PN}_${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtwebkit:4
	x11-libs/libX11
	x11-libs/libXtst
	kde? ( media-libs/phonon[qt4] )
	!kde? ( || ( dev-qt/qtphonon media-libs/phonon[qt4] ) )
"
RDEPEND="${DEPEND}"
