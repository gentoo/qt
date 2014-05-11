# Copyright 1999-2014 Gentoo Foundation
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
IUSE="debug doc static-libs test"

COMMON_DEPEND="app-crypt/qca:2[debug?]"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:4 )
"
RDEPEND="${COMMON_DEPEND}
	|| ( ~app-crypt/qca-9999:2[debug?,openssl,qt4] <app-crypt/qca-ossl-9999:2[debug?] )
"

DOCS="README CHANGELOG"

src_prepare() {
	qt4-r2_src_prepare

	if ! use test; then
		sed -i -e '/SUBDIRS/s/tests//' ${PN}.pro || die "sed failed"
	fi

	sed -i -e '/^ *docs \\$/d' \
		-e '/^ *build_all \\$/d' \
		-e 's/^\#\(!macx\)/\1/' \
		src/src.pro || die "sed failed"

	sed -i -e "s/\(.*\)lib$/\1$(get_libdir)/" src/pcfile.sh || die "sed failed"
}

src_compile() {
	default
	if use static-libs; then
		emake -C src static
	fi
}

src_install() {
	qt4-r2_src_install

	if use static-libs; then
		dolib.a "${S}"/lib/lib${PN}.a
	fi

	if use doc; then
		doxygen "${S}"/Doxyfile || die "failed to generate documentation"
		dohtml "${S}"/doc/html/*
	fi
}
