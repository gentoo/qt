# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="Common base library for the LXQt desktop environment"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"
IUSE="+qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? ( 
		~razorqt-base/libqtxdg-${PV}[qtmimetypes]
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtdbus:4
	)
	qt5? ( 
		~razorqt-base/libqtxdg-${PV}[qt5]
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtdbus:5
	)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrender"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt5 QT5)
	)
	cmake-utils_src_configure
}
