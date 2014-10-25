# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/razorqt-base/libqtxdg/libqtxdg-0.5.3.ebuild,v 1.3 2014/05/29 07:53:47 mrueg Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="A Qt implementation of XDG standards"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/libqtxdg/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

CDEPEND="sys-apps/file
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
DEPEND="${CDEPEND}
	test? ( dev-qt/qttest:5 )"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
		$(cmake-utils_use test BUILD_TESTS)
	)
	cmake-utils_src_configure
}
