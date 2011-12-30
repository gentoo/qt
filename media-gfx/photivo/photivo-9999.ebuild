# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 mercurial

DESCRIPTION="Photo processor for RAW and Bitmap images"
HOMEPAGE="http://www.photivo.org"
EHG_REPO_URI="https://photivo.googlecode.com/hg/"
EHG_REVISION="default"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gimp"

RDEPEND="x11-libs/qt-gui:4
	|| ( media-libs/jpeg:62 media-libs/libjpeg-turbo )
	media-gfx/exiv2
	media-libs/lcms:2
	media-libs/lensfun
	sci-libs/fftw:3.0
	media-libs/libpng:1.2
	>=media-libs/tiff-4.0.0_beta6
	media-libs/liblqr
	media-gfx/graphicsmagick[q16,-lcms]
	gimp? ( media-gfx/gimp )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/hg

src_prepare() {
#	remove ccache dependency
	for File in $(find ${S} -type f); do
		if grep -sq ccache ${File}; then
			sed -e 's/ccache//' -i "${File}"
		fi
	done
}

src_install() {
	qt4-r2_src_install
	
	if use gimp; then
		exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
		doexe ptGimp
		doexe "mm extern photivo.py"
	fi
}