# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON="2.5"
inherit eutils python

MY_PN="Q7Z"

DESCRIPTION="A GUI frontend for p7zip"
HOMEPAGE="http://code.google.com/p/k7z/"
SRC_URI="http://k7z.googlecode.com/files/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

DEPEND="app-arch/p7zip
	dev-python/PyQt4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}/Build"

src_prepare() {
	cd ..
	epatch "${FILESDIR}/${PV}-fix_paths.patch"
	epatch "${FILESDIR}/${PV}-fix_7z_flags.patch"
	epatch "${FILESDIR}/${PV}-fix_imports.patch"

	cd Source
	mv "${MY_PN}.pyw" "${PN}.pyw"
}

src_install() {
	python_version

	cd ..

	insinto "$(python_get_sitedir)/${PN}"
	doins Source/*.py
	newins "${FILESDIR}/${PV}-init.py" __init__.py

	insinto "/usr/share/${PN}/Options"
	doins Options/*
	insinto "/usr/share/${PN}/Profiles"
	doins Desktop/Profiles/*

	dobin "Source/${PN}.pyw"
	dosym "/usr/bin/${PN}.pyw" "/usr/bin/${PN}"
}

pkg_postinst() {
	python_version
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}

pkg_postrm() {
	python_mod_cleanup
}
