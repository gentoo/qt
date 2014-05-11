# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="A library creating and utilizing caches to speed up freedesktop.org application menus"
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

LICENSE="GPL-2"
SLOT="0/2"
IUSE=""

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README ) # ChangeLog is empty
