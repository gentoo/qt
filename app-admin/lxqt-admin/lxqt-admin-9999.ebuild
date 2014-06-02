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
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	~lxqt-base/liblxqt-${PV}"
RDEPEND="${DEPEND}"
