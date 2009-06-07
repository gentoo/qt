# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils

DESCRIPTION="A program to tune musical instruments using Qt4"
HOMEPAGE="http://www.webalice.it/wspinelli/qpitch/"
SRC_URI="http://download.gna.org/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	>=media-libs/portaudio-19_pre20071207
	>=sci-libs/fftw-3.1.0"
RDEPEND="${DEPEND}"

DOCS="README changelog"

