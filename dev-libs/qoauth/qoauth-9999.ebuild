# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="A Qt-based library for OAuth support"
HOMEPAGE="http://wiki.github.com/ayoy/qoauth"
EGIT_REPO_URI="git://github.com/ayoy/${PN}"

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
	qt4-r2_src_prepare
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
	emake -C src static
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dolib.a "${S}/lib/lib${PN}.a"
	dodoc README CHANGELOG

	if use doc; then
		doxygen "${S}/Doxyfile" || die "Failed to generate documentation"
		dohtml "${S}"/doc/html/*
	fi
}
