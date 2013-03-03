# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SCONS_MIN_VERSION="2.2"

inherit scons-utils toolchain-funcs

DESCRIPTION="File-manager-like GUI front-end to MPlayer"
HOMEPAGE="http://sourceforge.net/projects/qemplayer/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=dev-db/sqlite-3.7.14[threadsafe]
	|| ( media-video/mplayer media-video/mplayer2 )
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtgui-4.8:4
	>=dev-qt/qtsql-4.8:4[sqlite]
"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.4.7
	virtual/pkgconfig
"

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		local major=$(gcc-major-version)
		local minor=$(gcc-minor-version)
		if (( major < 4 || ( major == 4 && minor < 4 ) )); then
			die "gcc 4.4.7 or newer is required"
		fi
	fi
}

src_configure() {
	myesconsargs=(
		env=1
		final=1
		$(use_scons debug)
	)
}

src_compile() {
	escons
}

src_install() {
	dodir /usr
	escons install prefix="${D}"usr
}
