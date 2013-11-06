# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
VALA_MIN_API_VERSION="0.14"
inherit autotools-utils vala

DESCRIPTION="LXDE session manager"
HOMEPAGE="http://www.lxde.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/lxde/${PN}.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"
IUSE=""

# vala and gtk+ deps should be dropped later
CDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	sys-apps/dbus
	sys-auth/polkit
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${CDEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	lxde-base/lxqt-common"

src_prepare() {
	vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		"--sysconfdir=/etc --disable-buildin-clipboard --disable-buildin-polkit"
	)
	autotools-utils_src_configure
}
