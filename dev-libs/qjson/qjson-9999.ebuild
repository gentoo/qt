# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="A library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
EGIT_REPO_URI="git://github.com/flavio/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc +qt4 qt5 test"

RDEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)"

REQUIRED_USE="^^ ( qt4 qt5 )"

DOCS=( ChangeLog README.md )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 QT4_BUILD)
		$(cmake-utils_use test QJSON_BUILD_TESTS)
	)

	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		cd doc
		doxygen Doxyfile || die "Generating documentation failed"
		HTML_DOCS=( doc/html/ )
	fi

	cmake-utils_src_install
}
