# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sip/sip-4.8.1.ebuild,v 1.1 2009/06/16 15:07:22 hwoarang Exp $

EAPI="2"
NEED_PYTHON="2.3"

inherit python toolchain-funcs

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

src_configure() {
	python_version

	local myconf="${python} configure.py
			--bindir=/usr/bin
			--destdir=$(python_get_sitedir)
			--incdir=/usr/include/python${PYVER}
			--sipdir=/usr/share/sip
			$(use debug && echo '--debug')
			CC=$(tc-getCC) CXX=$(tc-getCXX)
			LINK=$(tc-getCXX) LINK_SHLIB=$(tc-getCXX)
			CFLAGS='${CFLAGS}' CXXFLAGS='${CXXFLAGS}'
			LFLAGS='${LDFLAGS}'
			STRIP=true"
	echo ${myconf}
	eval ${myconf} || die "configuration failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS || die

	if use doc; then
		dohtml -r doc/html/* || die
	fi
}

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize "$(python_get_sitedir)"/sip*.py
}

pkg_postrm() {
	python_mod_cleanup
}
