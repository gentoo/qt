# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pcmanfm-qt/pcmanfm-qt-9999.ebuild,v 1.2 2013/04/29 18:59:04 hwoarang Exp $

EAPI=5

inherit cmake-utils multilib readme.gentoo

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}"
	KEYWORDS=""
else
	SRC_URI="http://lxqt.org/downloads/${PV}/${P}.tar.xz"
	S="${WORKDIR}"/${P}-Source
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Fast lightweight tabbed filemanager (Qt4 port)"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="vala"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	dev-qt/qtgui:4
	dev-qt/qtdbus:4
	>=lxde-base/menu-cache-0.3.2
	>=x11-libs/libfm-1.2.0"
RDEPEND="${COMMON_DEPEND}
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

src_unpack() {
	default
	S=${WORKDIR}
}

src_prepare() {
	# fix multilib
	sed -i -e "/LIBRARY\ DESTINATION/s:lib:$(get_libdir):" \
		libfm-qt/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	DOC_CONTENTS="Be sure to set an icon theme in Edit > Preferences > User Interface"
	readme.gentoo_src_install
}
