# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit kde4-base

DESCRIPTION="KCM module for SDDM - Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm-kcm"
EGIT_REPO_URI="git://github.com/sddm/sddm-kcm.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtdeclarative:4
	x11-misc/sddm[qt4]"
RDEPEND="${DEPEND}"
