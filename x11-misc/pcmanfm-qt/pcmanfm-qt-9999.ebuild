# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils readme.gentoo

DESCRIPTION="Qt version of PCManFM file manager"
HOMEPAGE="http://blog.lxde.org/?p=982"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://pcmanfm.git.sourceforge.net/gitroot/pcmanfm/${PN}"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-libs/glib:2
	dev-qt/qtgui:4[dbus,glib]
	>=x11-libs/libfm-1.1.0"
RDEPEND="${DEPEND}"

src_install() {
	DOC_CONTENTS="Be sure to set an icon theme in Edit > Preferences > User Interface"
	readme.gentoo_src_install
}
