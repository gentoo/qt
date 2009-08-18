# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.38.0[python]
	dev-python/boostpythongenerator
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}"

