# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt OpenSSH user password prompt tool"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="http://lxqt.org/downloads/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	lxqt-base/liblxqt"
DEPEND="${RDEPEND}"

src_unpack() {
	default
	S=${WORKDIR}
}

src_install(){
	cmake-utils_src_install
	doman man/*.1
}
