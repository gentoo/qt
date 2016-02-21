# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="http://quazip.sourceforge.net/"
ESVN_REPO_URI="svn://svn.code.sf.net/p/quazip/code/trunk/quazip"
ESVN_PROJECT="quazip"

inherit cmake-utils subversion

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc +qt4 qt5 test"

RDEPEND="
	sys-libs/zlib[minizip]
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)"

REQUIRED_USE="^^ ( qt4 qt5 )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 BUILD_WITH_QT4)
	)

	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		doxygen Doxyfile || die "Generating documentation failed"
		HTML_DOCS=( doc/html/ )
	fi

	cmake-utils_src_install
}
