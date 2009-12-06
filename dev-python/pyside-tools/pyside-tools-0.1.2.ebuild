# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="PySide development tools"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-python/pyside-0.2.1
	>=x11-libs/qt-core-4.5.0
	>=x11-libs/qt-gui-4.5.0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-qtgui.patch"
}

src_install() {
	cmake-utils_src_install
	dobin pyside-uic || die "installing pyside-uic failed"
	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
