# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SCONS_MIN_VERSION="2.1"
inherit flag-o-matic eutils scons-utils

DESCRIPTION="File-manager-like Qt4 GUI front-end to MPlayer"
HOMEPAGE="http://sourceforge.net/projects/qemplayer/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-db/sqlite-3.7.13[threadsafe]
	>=dev-libs/libsigc++-2.2.10
	|| ( media-video/mplayer media-video/mplayer2 )
	>=x11-libs/qt-gui-4.8:4
	>=x11-libs/qt-sql-4.8:4[sqlite]"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.4.7
	virtual/pkgconfig"

pkg_setup() {
	local major=$(gcc-major-version)
	local minor=$(gcc-minor-version)
	if (( major < 4 || ( major == 4 && minor < 4 ) )); then
		die "gcc 4.4.7 or newer is required"
	fi
}

src_configure() {
	myesconsargs=(
		 final=1
		 env=1
		 -j1
		 $(use_scons debug)
	)
}

src_compile() {
	escons
}

src_install() {
	dodir /usr
	escons install prefix="${D}"usr
	dodoc INSTALL README CHANGES
}
