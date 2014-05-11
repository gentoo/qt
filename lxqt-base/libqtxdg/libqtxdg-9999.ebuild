# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="A Qt implementation of XDG standards"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/libqtxdg.git"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+qt4 qt5 test"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="sys-apps/file
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4
		test? ( dev-qt/qttest:4 )
	)
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtxml:5
		dev-qt/qtwidgets:5
		dev-qt/qttools:5
		test? ( dev-qt/qttest:5 )
	)"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

src_configure() {
	local mycmakeargs
	mycmakeargs=(
		$(cmake-utils_use_use qt5 QT5)
		$(cmake-utils_use test BUILD_TESTS)
	)
	cmake-utils_src_configure
}
