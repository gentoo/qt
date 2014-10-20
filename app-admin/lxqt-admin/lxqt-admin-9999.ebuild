# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt system administration tool"
HOMEPAGE="http://www.lxqt.org/"

inherit git-r3
EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"

LICENSE="LGPL-2.1+"
SLOT="0"

DEPEND="dev-libs/glib:2
	dev-libs/liboobs
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	~lxqt-base/liblxqt-${PV}
	>=razorqt-base/libqtxdg-1.0.0
	x11-libs/libX11
"
RDEPEND="${DEPEND}"
