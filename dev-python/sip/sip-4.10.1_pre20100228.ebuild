# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEFINE_DEFAULT_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

EHG_REPO_URI="http://www.riverbankcomputing.com/hg/sip"
[[ ${PV} == *9999* ]] && HG_ECLASS="mercurial"

inherit eutils python toolchain-funcs ${HG_ECLASS}

HG_REVISION="637497440cb5"

DESCRIPTION="Python bindings generator for C and C++ libraries"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/sip/intro http://pypi.python.org/pypi/SIP"
LICENSE="|| ( GPL-2 GPL-3 sip )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="debug doc"

DEPEND=""
RDEPEND=""

if [[ ${PV} == *9999* ]]; then
	# live version from mercurial repo
	DEPEND="${DEPEND}
		sys-devel/bison
		sys-devel/flex"
	S=${WORKDIR}/${PN}
elif [[ ${PV} == *_pre* ]]; then
	# development snapshot
	DEPEND="${DEPEND}
		sys-devel/bison
		sys-devel/flex"
	SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${PN}-snapshot-${PV/_pre*/}-${HG_REVISION}.tar.gz"
	S=${WORKDIR}/${PN}-snapshot-${PV/_pre*/}-${HG_REVISION}
else
	# official stable release
	SRC_URI="http://www.riverbankcomputing.com/static/Downloads/sip${PV%%.*}/${P}.tar.gz"
fi

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

	dodoc NEWS || die

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
