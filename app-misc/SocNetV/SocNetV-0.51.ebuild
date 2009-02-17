# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="http://socnetv.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/socnetv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="x11-libs/qt-gui:4
		x11-libs/qt-webkit:4"

S="${WORKDIR}/socnetv-${PV}"

src_install() {
	dobin socnetv || die "dobin failed"
	doicon src/images/socnetv.png || die "doicon failed"
	make_desktop_entry  socnetv "${PN}" socnetv.png 'Science' \
		|| die "make_desktop_entry failed"
	insinto /usr/share/${PN}/examples || die "insinto failed"
	doins nets/* || die "doins failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
	if use doc; then
		dohtml -r "${S}"/doc/* || die "dohtml failed"
	fi
}
