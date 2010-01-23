# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="+abiword cairo cjk debug doc exceptions glib jpeg +lcms openjpeg png qt4 +utils +xpdf-headers"

COMMON_DEPEND="
	>=media-libs/fontconfig-2.6.0
	>=media-libs/freetype-2.3.9
	sys-libs/zlib
	abiword? ( dev-libs/libxml2:2 )
	glib? (
		dev-libs/glib:2
		cairo? (
			>=x11-libs/cairo-1.8.4
			>=x11-libs/gtk+-2.14.0:2
		)
	)
	jpeg? ( >=media-libs/jpeg-7:0 )
	openjpeg? ( media-libs/openjpeg )
	png? ( media-libs/libpng )
	qt4? (
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
	)
"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!virtual/poppler
	!virtual/poppler-glib
	!virtual/poppler-qt3
	!virtual/poppler-qt4
	!virtual/poppler-utils
	cjk? ( >=app-text/poppler-data-0.2.1 )
"

src_prepare() {
	epatch "${FILESDIR}/${P}-cmake-disable-tests.patch"
}

src_configure() {
	mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT4_TESTS=OFF
		-DWITH_Qt3=OFF
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		$(cmake-utils_use_enable abiword)
		$(cmake-utils_use_enable lcms)
		$(cmake-utils_use_enable openjpeg LIBOPENJPEG)
		$(cmake-utils_use_enable utils)
		$(cmake-utils_use_enable xpdf-headers XPDF_HEADERS)
		$(cmake-utils_use_with cairo)
		$(cmake-utils_use_with glib GTK)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with qt4)
		$(cmake-utils_use exceptions USE_EXCEPTIONS)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# For now install gtk-doc there
	if use glib && use doc; then
		insinto /usr/share/gtk-doc/html/poppler
		doins -r "${S}"/glib/reference/html/* || die 'failed to install API documentation'
	fi
}
