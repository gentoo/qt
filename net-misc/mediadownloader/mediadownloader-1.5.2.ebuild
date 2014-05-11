# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2

DESCRIPTION="Qt4 application for searching, watching and downloading items with Google Images and YouTube"
HOMEPAGE="http://sourceforge.net/projects/googleimagedown"
SRC_URI="mirror://sourceforge/googleimagedown/${PN}_${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND="
	x11-libs/libX11
	x11-libs/libXtst
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtwebkit:4
	kde? ( media-libs/phonon )
	!kde? ( || ( dev-qt/qtphonon media-libs/phonon ) )
"
RDEPEND="${DEPEND}"
