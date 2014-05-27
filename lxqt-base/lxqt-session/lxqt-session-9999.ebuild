# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="LXQT session manager"
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

CDEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus
	dev-qt/qtgui:4
	lxqt-base/liblxqt
	razorqt-base/libqtxdg
	x11-libs/libX11"
DEPEND="${CDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	lxqt-base/lxqt-common"

src_install(){
	cmake-utils_src_install
	doman lxqt-config-session/man/*.1 lxqt-session/man/*.1
}
