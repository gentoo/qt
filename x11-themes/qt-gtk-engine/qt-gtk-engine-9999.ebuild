# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt GTK3 to QT Rendering Engine"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	#mirror not transferred over yet...
	#EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
	EGIT_REPO_URI="https://github.com/lxde/qt-gtk-engine.git"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	lxqt-base/liblxqt
	x11-libs/libX11"
RDEPEND="${DEPEND}"
