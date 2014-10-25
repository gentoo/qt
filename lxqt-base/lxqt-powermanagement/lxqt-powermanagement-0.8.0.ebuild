# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-powermanagement/lxqt-powermanagement-0.7.0.ebuild,v 1.3 2014/09/12 14:24:39 jauhien Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt daemon for power management and auto-suspend"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="
	x11-libs/libX11
	x11-libs/libxcb
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	>=lxqt-base/liblxqt-0.8.0
	>=razorqt-base/libqtxdg-1.0.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}
