# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="LXQt Clipboard History Applet"
HOMEPAGE="
	https://lxqt-project.org/
	https://github.com/lxqt/lxqt-clip/
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# qmenuview/* and qxt/* are licensed under GPL-3+ and BSD respectively.
LICENSE="BSD GPL-2+ GPL-3+"
SLOT="0"

BDEPEND="dev-qt/qttools:6[linguist]"
RDEPEND="
	dev-qt/qtbase:6=[gui,widgets]
	dev-qt/qtsvg:6
	kde-frameworks/kguiaddons:6
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
