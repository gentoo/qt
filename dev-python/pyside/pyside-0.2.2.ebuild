# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

MY_P="${PN}-qt4.5+${PV}"

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.41.0[python]
	>=dev-python/boostpythongenerator-0.3.2
	>=x11-libs/qt-core-4.5.0
	>=x11-libs/qt-assistant-4.5.0
	>=x11-libs/qt-gui-4.5.0
	>=x11-libs/qt-opengl-4.5.0
	|| ( >=x11-libs/qt-phonon-4.5.0 media-sound/phonon )
	>=x11-libs/qt-script-4.5.0
	>=x11-libs/qt-sql-4.5.0
	>=x11-libs/qt-svg-4.5.0
	>=x11-libs/qt-webkit-4.5.0
	>=x11-libs/qt-xmlpatterns-4.5.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-qtscripttools.patch"
	sed -e 's/-2.6//' -i data/CMakeLists.txt || die "sed failed"
}
