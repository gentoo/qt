# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/shiboken/shiboken-0.3.2.ebuild,v 1.2 2010/06/16 19:36:37 ayoy Exp $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/pyside/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-python/apiextractor-0.6.0
	>=dev-python/generatorrunner-0.5.0
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}
	!dev-python/boostpythongenerator"
