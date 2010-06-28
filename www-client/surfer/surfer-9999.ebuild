# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="pt_BR"
lANGSLONG="ru_RU"
inherit cmake-utils git

DESCRIPTION="QtWebkit browser focusing on usability"
HOMEPAGE="http://qt-apps.org/content/show.php/Surfer?content=110535"
EGIT_REPO_URI="git://gitorious.org/surfer/surfer.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/qt-webkit-4.6.0"
RDEPEND="${DEPEND}"
