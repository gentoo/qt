# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/liblxqt/liblxqt-0.7.0.ebuild,v 1.3 2014/05/29 08:01:16 mrueg Exp $

EAPI=5
inherit cmake-utils multilib
#readme.gentoo

DESCRIPTION="Common base library for the LXQt desktop environment"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

DEPEND="
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrender
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=razorqt-base/libqtxdg-1.0.0"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}
