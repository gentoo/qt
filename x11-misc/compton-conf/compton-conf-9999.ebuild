# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt Compton Composite configuration tools"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="http://lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="qt4 +qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="x11-libs/libX11
	x11-misc/compton
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtwidgets:5 )"
DEPEND="${RDEPEND}
	dev-libs/libconfig
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		$( cmake-utils_use_use qt5 QT5 )
	)
	cmake-utils_src_configure
}
