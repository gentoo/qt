# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/liblastfm/liblastfm-1.0.7.ebuild,v 1.3 2013/08/19 14:39:30 kensington Exp $

EAPI=5

QT4_MINIMAL="4.8.0"
inherit cmake-utils git-2

DESCRIPTION="A Qt C++ library for the Last.fm webservices"
HOMEPAGE="https://github.com/lastfm/liblastfm"
EGIT_REPO_URI="git://github.com/lastfm/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="fingerprint +qt4 qt5 test"
REQUIRED_USE="^^ ( qt4 qt5 )"

COMMON_DEPEND="
	qt4? (
		>=dev-qt/qtcore-${QT4_MINIMAL}:4
		>=dev-qt/qtdbus-${QT4_MINIMAL}:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
	)
	fingerprint? (
		media-libs/libsamplerate
		sci-libs/fftw:3.0
		qt4? ( >=dev-qt/qtsql-${QT4_MINIMAL}:4 )
		qt5? ( dev-qt/qtsql:5 )
	)
"
DEPEND="${COMMON_DEPEND}
	test? (
		qt4? ( >=dev-qt/qttest-${QT4_MINIMAL}:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/lastfmlib-0.4.0
"

# 1 of 2 is failing, last checked version 1.0.7
RESTRICT="test"

src_configure() {
	# demos not working
	# qt5 support broken
	local mycmakeargs=(
		-DBUILD_DEMOS=OFF
		$(cmake-utils_use_build qt4 WITH_QT4)
		$(cmake-utils_use_build fingerprint)
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}
