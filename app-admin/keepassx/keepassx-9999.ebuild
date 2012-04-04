# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 cmake-utils git-2

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions."
HOMEPAGE="http://keepassx.sourceforge.net/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}"

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug test"

RDEPEND="dev-libs/libgcrypt
	sys-libs/zlib
	x11-libs/qt-core:4[qt3support]
	x11-libs/qt-gui:4[qt3support]
"
DEPEND="${RDEPEND}
	test? ( x11-libs/qt-test:4 )
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with test TESTS)
		-DWITH_GUI_TESTS=OFF
	)

	cmake-utils_src_configure
}
