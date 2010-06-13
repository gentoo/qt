# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/pyside/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~dev-python/apiextractor-${PV}
	~dev-python/generatorrunner-${PV}
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog || die "dodc failed"
}
