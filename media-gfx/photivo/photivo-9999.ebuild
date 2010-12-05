# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 mercurial

DESCRIPTION="Photo processor for RAW and Bitmap images"
HOMEPAGE="http://www.photivo.org"
EHG_REPO_URI="https://photivo.googlecode.com/hg/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE=""

RDEPEND="x11-libs/qt-gui:4
	media-libs/jpeg:62
	media-gfx/exiv2
	media-libs/lcms:2
	media-libs/lensfun
	sci-libs/fftw:3.0
	media-libs/libpng:1.2
	>=media-libs/tiff-4.0.0_beta6
	media-gfx/graphicsmagick[q16]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/hg
