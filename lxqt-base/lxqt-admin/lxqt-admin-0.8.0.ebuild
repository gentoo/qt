# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-about/lxqt-about-0.7.0.ebuild,v 1.2 2014/05/29 08:01:38 mrueg Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt administration tool"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

DEPEND="
	dev-libs/liboobs
	dev-qt/qtwidgets:5
	>=lxqt-base/liblxqt-0.8.0"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}
