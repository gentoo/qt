# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sip/sip-4.10.ebuild,v 1.1 2010/01/15 14:52:28 yngwin Exp $

EAPI="2"
PYTHON_DEFINE_DEFAULT_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python toolchain-funcs
# Mercurial Revision
REVISION="e3611c1babe7"
MY_PN="${PN}-snapshot"
MY_P="${MY_PN}-${PV/_pre*/}-${REVISION}"

DESCRIPTION="A tool for generating bindings for C++ classes so that they can be used by Python"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/sip/intro http://pypi.python.org/pypi/SIP"
#SRC_URI="http://www.riverbankcomputing.com/static/Downloads/${PN}${PV%%.*}/${MY_P}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 sip )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="debug doc"

S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.9.3-darwin.patch
	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf="$(PYTHON) configure.py
				--bindir=${EPREFIX}/usr/bin
				--destdir=${EPREFIX}$(python_get_sitedir)
				--incdir=${EPREFIX}$(python_get_includedir)
				--sipdir=${EPREFIX}/usr/share/sip
				$(use debug && echo '--debug')
				CC=$(tc-getCC) CXX=$(tc-getCXX)
				LINK=$(tc-getCXX) LINK_SHLIB=$(tc-getCXX)
				CFLAGS='${CFLAGS}' CXXFLAGS='${CXXFLAGS}'
				LFLAGS='${LDFLAGS}'
				STRIP=true"
		echo ${myconf}
		eval ${myconf}
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install

	dodoc README NEWS || die

	if use doc; then
		dohtml -r doc/html/* || die
	fi
}

pkg_postinst() {
	python_mod_optimize sipconfig.py sipdistutils.py

	ewarn 'When updating sip, you usually need to recompile packages that'
	ewarn 'depend on sip, such as PyQt4 and qscintilla-python. If you have'
	ewarn 'app-portage/gentoolkit installed you can find these packages with'
	ewarn '`equery d sip` and `equery d PyQt4`.'
}

pkg_postrm() {
	python_mod_cleanup sipconfig.py sipdistutils.py
}
