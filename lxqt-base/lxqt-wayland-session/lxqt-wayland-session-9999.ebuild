# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake

DESCRIPTION="LXQt Wayland Session Support"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD GPL-2 GPL-3 LGPL-2.1 MIT"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.1.0
	virtual/pkgconfig
"
DEPEND="
	>=app-misc/qtxdg-tools-4.1.0
	kde-plasma/layer-shell-qt:6
	=lxqt-base/lxqt-session-${MY_PV}*
	x11-misc/xdg-user-dirs
"
RDEPEND="${DEPEND}"
