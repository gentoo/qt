# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils mercurial

EHG_REPO_URI="http://www.logilab.org/cgi-bin/hgwebdir.cgi/hgview"

DESCRIPTION="PyQt4 based Mercurial log navigator"
HOMEPAGE="http://www.logilab.org/project/name/hgview"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="dev-vcs/mercurial
	dev-python/egenix-mx-base
	dev-python/PyQt4[X]
	dev-python/qscintilla-python
	dev-python/docutils
	doc? ( app-text/asciidoc )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"

src_prepare() {
	distutils_src_prepare

	# fix mercurial extension install path
	if ! use doc; then
		sed -i '/make -C doc/d' "${S}/setup.py" || die "sed failed"
		sed -i '/share\/man\/man1/,+1 d' "${S}/hgviewlib/__pkginfo__.py" || die "sed failed"
	fi
}

src_install() {
	distutils_src_install

	# install the mercurial extension config
	insinto /etc/mercurial/hgrc.d || die
	doins hgext/hgview.rc || die
}
