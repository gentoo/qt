# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 git

CPPUNIT_REQUIRED="optional"

DESCRIPTION="GUI interface for git/cogito SCM"
HOMEPAGE="http://digilander.libero.it/mcostalba/"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/qgit/qgit4.git"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="2"
IUSE=""

DEPEND="
	>=x11-libs/qt-gui-4.4:4
"
RDEPEND="${DEPEND}
	>=dev-util/git-1.5.3
"

src_compile() {
	eqmake4 || die "eqmake failed"
	emake || die "emake failed"
}

src_install() {
	newbin bin/qgit qgit4
	dodoc README
}

pkg_postinst() {
	elog "This is installed as qgit4 now so you can still use 1.5 series (Qt3-based)"
}
