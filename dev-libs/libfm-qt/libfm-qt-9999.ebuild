# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Qt enhancement of libfm, a library for filemanagement"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="LGPL-2.1+"
SLOT="0"

CDEPEND=">=dev-libs/glib-2.18:2
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=lxde-base/menu-cache-0.4.1
	>=x11-libs/libfm-1.2.0
"
RDEPEND="${CDEPEND}
"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
