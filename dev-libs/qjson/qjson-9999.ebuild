# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="A library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test"

RDEPEND="x11-libs/qt-core:4"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"
DOCS=( "${S}/README" )

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use test QJSON_BUILD_TESTS)"

	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		cd "${S}/doc"
		doxygen Doxyfile || die "Generating documentation failed"
		HTML_DOCS=( "${S}/doc/html/*" )
	fi

	cmake-utils_src_install
}
