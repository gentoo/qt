# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt common resources"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="lxqt-base/liblxqt"
RDEPEND="${DEPEND}
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4"

src_unpack() {
	default
	S=${WORKDIR}
}
src_prepare() {
	cmake-utils_src_prepare
	sed -i -e 's!^Exec=startlxde-qt!TryExec=lxqt-session\nExec=/etc/X11/Sessions/lxqt!' xsession/lxqt.desktop.in || die
}

src_install() {
	cmake-utils_src_install
	dodir "/etc/X11/Sessions"
	mv "${D}/usr/bin/startlxqt" "${D}/etc/X11/Sessions/lxqt" || die
	dosym "/etc/X11/Sessions/lxqt" "/usr/bin/startlxqt"
}
