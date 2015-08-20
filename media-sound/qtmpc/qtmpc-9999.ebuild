# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_REQUIRED="optional"
inherit qt4-r2 kde4-base subversion

DESCRIPTION="Qt MPD client with a tree view music library interface"
HOMEPAGE="http://lowblog.nl/category/qtmpc/"
ESVN_REPO_URI="http://qtmpc.lowblog.nl/svn/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug kde"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/QtMPC"

src_configure() {
	if use kde; then
		kde4-base_src_configure
	else
		eqmake4 QtMPC.pro
	fi
}

src_compile() {
	if use kde; then
		kde4-base_src_compile
	else
		default
	fi
}

src_install() {
	dodoc CHANGELOG || die "dodoc failed"
	newicon images/icon.svg ${PN}.svg || die "Icon install failed"
	make_desktop_entry QtMPC "QtMPC" ${PN} \
		"Qt;AudioVideo;Audio;" || die "Desktop entry creation failed"

	if use kde; then
		kde4-base_src_install
	else
		dobin QtMPC || die "Binary install failed"
	fi
}
