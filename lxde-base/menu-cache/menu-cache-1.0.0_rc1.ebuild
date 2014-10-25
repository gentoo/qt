# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/menu-cache/menu-cache-0.5.1.ebuild,v 1.6 2014/03/04 20:25:45 vincent Exp $

EAPI="5"

DESCRIPTION="A library creating and utilizing caches to speed up freedesktop.org application menus"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/lxde/files/${PN}/1.0/${PN}-1.0.0-rc1.tar.xz -> ${P}.tar.xz"
LICENSE="GPL-2"

# ABI is v2. See Makefile.am
SLOT="0/2"
KEYWORDS="~alpha amd64 arm ~mips ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${PN}-1.0.0-rc1"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
