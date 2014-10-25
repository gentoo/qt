# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-runner/lxqt-runner-0.7.0-r1.ebuild,v 1.2 2014/05/29 08:24:15 mrueg Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt quick launcher"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	>=lxde-base/menu-cache-1.0.0_rc1
	>=lxqt-base/liblxqt-0.8.0
	>=lxqt-base/lxqt-globalkeys-0.8.0
	>=razorqt-base/libqtxdg-1.0.0
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman man/*.1
}
