# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

EHG_REPO_URI="http://www.riverbankcomputing.com/hg/sip"
[[ ${PV} == *9999* ]] && HG_ECLASS="mercurial"

inherit eutils python toolchain-funcs ${HG_ECLASS}

HG_REVISION=f95ee221598d

DESCRIPTION="Python extension module generator for C and C++ libraries"
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
	MY_P=${PN}-${PV%_pre*}-snapshot-${HG_REVISION}
	SRC_URI="http://www.gentoo-el.org/~hwoarang/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.9.3-darwin.patch

	if [[ ${PV} == *9999* ]]; then
		$(PYTHON -2) build.py prepare || die
	fi

	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf=("$(PYTHON)"
			configure.py
			--bindir="${EPREFIX}/usr/bin"
			--incdir="${EPREFIX}$(python_get_includedir)"
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			$(use debug && echo --debug)
			CC="$(tc-getCC)"
			CXX="$(tc-getCXX)"
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			CFLAGS="${CFLAGS}"
			CXXFLAGS="${CXXFLAGS}"
			LFLAGS="${LDFLAGS}"
			STRIP=":")
		echo "${myconf[@]}"
		"${myconf[@]}"
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install

	dodoc NEWS || die "dodoc failed"

	if use doc; then
		dohtml -r doc/html/* || die "dohtml failed"
	fi
}

pkg_postinst() {
	python_mod_optimize sipconfig.py sipdistutils.py

	ewarn "When updating dev-python/sip, you usually need to rebuild packages, which depend on dev-python/sip,"
	ewarn "such as dev-python/PyQt4 and dev-python/qscintilla-python. If you have app-portage/gentoolkit"
	ewarn "installed, you can find these packages with \`equery d dev-python/sip dev-python/PyQt4\`."
}

pkg_postrm() {
	python_mod_cleanup sipconfig.py sipdistutils.py
}
