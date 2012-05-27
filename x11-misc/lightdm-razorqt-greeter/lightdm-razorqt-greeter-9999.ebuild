# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="LightDM greeter for Razor-qt"
HOMEPAGE="http://razor-qt.org"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-misc/lightdm[qt4]
	=x11-wm/razorqt-0.4.1*"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/Build-against-0.4.1.patch"
	"${FILESDIR}/Build-only-greeter.patch"
)
