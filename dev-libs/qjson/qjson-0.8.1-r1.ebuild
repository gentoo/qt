# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qjson/qjson-0.8.1.ebuild,v 1.8 2013/04/02 20:56:14 ago Exp $

EAPI=5

inherit base cmake-multilib

DESCRIPTION="A library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
SRC_URI="mirror://github/flavio/qjson/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug doc test"

RDEPEND="dev-qt/qtcore:4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:4[${MULTILIB_USEDEP}] )"

DOCS=( ChangeLog README.md )

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use test QJSON_BUILD_TESTS)
		-DQT_QMAKE_EXECUTABLE=/usr/$(get_libdir)/qt4/bin/qmake
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	if use doc; then
		cd doc
		doxygen Doxyfile || die "Generating documentation failed"
		HTML_DOCS=( doc/html/ )
		base_src_install_docs
	fi
}
