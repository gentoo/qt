# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt keyboard and mouse configuration"
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

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	x11-libs/libX11"
DEPEND="${RDEPEND}"
