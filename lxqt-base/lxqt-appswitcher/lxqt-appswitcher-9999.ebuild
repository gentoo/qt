# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt applications switcher"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="lxqt-base/liblxqt
	lxqt-base/lxqt-globalkeys
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	x11-libs/libX11"
RDEPEND="${DEPEND}"
