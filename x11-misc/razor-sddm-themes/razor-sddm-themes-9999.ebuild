# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-2

DESCRIPTION="Razor-qt themes for SDDM"
HOMEPAGE="https://github.com/Adys/razor-sddm-themes"
EGIT_REPO_URI="git://github.com/Adys/razor-sddm-themes.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="x11-misc/sddm"

src_install() {
	insinto /usr/share/apps/sddm/themes/
	doins -r razor-light
}
