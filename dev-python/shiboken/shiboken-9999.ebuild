# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/pyside/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=dev-python/apiextractor-0.6.0
	>=dev-python/generatorrunner-0.5.0
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}
	!dev-python/boostpythongenerator"
