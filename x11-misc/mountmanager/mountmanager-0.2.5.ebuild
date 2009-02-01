# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib

DESCRIPTION="A Qt4 GUI for managing mounts"
HOMEPAGE="http://www.qt-apps.org/content/show.php/MountManager?content=78270"
SRC_URI="http://linuxtuner.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[dbus,glib]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	sed -i "s:portage_d:${D}:" configure || die "sed failed"
}

src_configure() {
	./configure --lib_path=/usr/$(get_libdir) || die "configure failed"
}

src_install() {
	emake install || die "emake install failed"
	dodoc readme.en
}
