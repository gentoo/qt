# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="Daemon and library for global keyboard shortcuts registration"
HOMEPAGE="http://www.lxde.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/lxde/${PN}.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="lxde-base/liblxqt
	x11-libs/libX11
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"
