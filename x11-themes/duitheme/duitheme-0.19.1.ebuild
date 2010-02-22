# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 git

DESCRIPTION="The Harmattan development theme"
HOMEPAGE="http://duiframework.wordpress.com"
EGIT_REPO_URI="git://gitorious.org/maemo-6-ui-framework/duitheme.git"
EGIT_COMMIT="1f84bbcc1dae0286d0a4f16bc0bd8b375a23428c"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-core:4"
RDEPEND=">=x11-libs/qt-svg-4.6.0:4"
