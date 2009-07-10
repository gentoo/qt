# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

DESCRIPTION="PyQt4 based Mercurial log navigator"
HOMEPAGE="http://www.logilab.org/project/name/hgview"
SRC_URI="http://ftp.logilab.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/egenix-mx-base
	dev-python/PyQt4[X]
	dev-python/qscintilla-python"
RDEPEND="${DEPEND}"

src_prepare() {
	distutils_src_prepare

	# fix mercurial extension install path
	local origdir="share/python-support/mercurial-common/hgext"
	local sitedir="$(python_get_sitedir)/hgext"
	sed -i -e "s:${origdir}:${sitedir#/usr/}:" \
		"${S}/hgviewlib/__pkginfo__.py" || die "sed failed"
}

src_install() {
	distutils_src_install

	# install the mercurial extension config
	insinto /etc/mercurial/hgrc.d || die
	doins hgext/hgview.rc || die
}
