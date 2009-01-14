# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils git qt4

EGIT_REPO_URI="git://github.com/Arora/arora.git"
DESCRIPTION="A cross-platform Qt4 WebKit browser"
HOMEPAGE="http://arora.googlecode.com/"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/qt-webkit:4"
DEPEND="${RDEPEND}"

src_compile() {
	eqmake4 arora.pro PREFIX="${D}/usr"
	emake || die "make failed"

	# don't pre-strip
	sed -i "/strip/d" src/Makefile || die 'sed failed'
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
}
