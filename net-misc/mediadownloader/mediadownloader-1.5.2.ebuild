# Copyright 1999-2013 Gentoo Foundation
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
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-webkit:4
	kde? ( media-libs/phonon )
	!kde? ( || ( x11-libs/qt-phonon media-libs/phonon ) )
"
RDEPEND="${DEPEND}"
