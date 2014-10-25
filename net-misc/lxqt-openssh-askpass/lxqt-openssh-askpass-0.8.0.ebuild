# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt OpenSSH user password prompt tool"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/linguist-tools:5
	>=lxqt-base/liblxqt-0.8.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman man/*.1

	echo "SSH_ASKPASS='${EPREFIX}/usr/bin/lxqt-openssh-askpass'" >> "${T}/99${PN}" \
	|| die
	doenvd "${T}/99${PN}"
}
