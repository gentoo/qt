# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sip/sip-4.8.2.ebuild,v 1.2 2009/08/01 23:31:41 arfrever Exp $

EAPI="2"
NEED_PYTHON="2.3"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python toolchain-funcs

MY_P=${P/_pre/-snapshot-}

DESCRIPTION="A tool for generating bindings for C++ classes so that they can be used by Python"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/sip/intro"
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${MY_P}.tar.gz"

LICENSE="sip"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc"

S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=""

src_prepare() {
	python_copy_sources
}

src_configure() {
	configure_package() {
		local myconf="$(PYTHON) configure.py
				--bindir=/usr/bin
				--destdir=$(python_get_sitedir)
				--incdir=$(python_get_includedir)
				--sipdir=/usr/share/sip
				$(use debug && echo '--debug')
				CC=$(tc-getCC) CXX=$(tc-getCXX)
				LINK=$(tc-getCXX) LINK_SHLIB=$(tc-getCXX)
				CFLAGS='${CFLAGS}' CXXFLAGS='${CXXFLAGS}'
				LFLAGS='${LDFLAGS}'
				STRIP=true"
		echo ${myconf}
		eval ${myconf}
	}
	python_execute_function -s configure_package
}

src_compile() {
	python_execute_function -d -s
}

src_install() {
	python_need_rebuild

	python_execute_function -d -s

	dodoc ChangeLog NEWS || die

	if use doc; then
		dohtml -r doc/html/* || die
	fi
}

pkg_postinst() {
	python_mod_optimize sipconfig.py sipdistutils.py
}

pkg_postrm() {
	python_mod_cleanup
}
