# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="User authentication library for Qt"
HOMEPAGE="https://github.com/MartinBriza/QAuth"
EGIT_REPO_URI="https://github.com/MartinBriza/QAuth.git"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="virtual/pam
	qt4? ( dev-qt/qtdeclarative:4 )
	qt5? ( dev-qt/qtdeclarative:5 )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt5 QT5)
	)

	cmake-utils_src_configure
}
