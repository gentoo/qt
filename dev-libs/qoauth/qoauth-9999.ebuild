# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge git

DESCRIPTION="A Qt-based library for OAuth support"
HOMEPAGE="http://wiki.github.com/ayoy/qoauth"
EGIT_REPO_URI="git://github.com/ayoy/qoauth.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test"

COMMON_DEPEND="app-crypt/qca:2[debug?]"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca-ossl:2[debug?]"

src_prepare() {
	qt4-edge_src_prepare
	sed -i -e '/^ *docs \\$/d' \
	       -e '/^ *build_all \\$/d' \
	       -e 's/^\#\(!macx\)/\1/' \
	    src/src.pro || die "sed failed"

	sed -i -e "s/\(.*\)lib$/\1$(get_libdir)/" src/pcfile.sh || die "sed failed"

	if ! use test; then
		sed -i -e 's/^\(SUBDIRS.*\) tests/\1/' ${PN}.pro || die "sed failed"
	fi
}

src_compile() {
	default
	emake -C src static || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dolib.a "${S}/lib/lib${PN}.a" || die "dolib failed"
	dodoc README CHANGELOG || die "dodoc failed"

	if use doc; then
		doxygen "${S}/Doxyfile" || die "Failed to generate documentation"
		dohtml "${S}"/doc/html/* || die "Failed to install documentation"
	fi
}
