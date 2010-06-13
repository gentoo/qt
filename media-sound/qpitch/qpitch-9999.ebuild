# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils subversion

DESCRIPTION="A program to tune musical instruments using Qt4"
HOMEPAGE="http://wspinell.altervista.org/qpitch/"
ESVN_REPO_URI="svn://svn.gna.org/svn/qpitch/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-gui:4
	>=media-libs/portaudio-19_pre20071207
	>=sci-libs/fftw-3.1.0"
RDEPEND="${DEPEND}"

DOCS=(README changelog)
