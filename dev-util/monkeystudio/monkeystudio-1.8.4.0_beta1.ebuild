# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4

MY_PN="mks"
MY_PV="${PV/_beta/b}-svn3231"
MY_P="${MY_PN}_${MY_PV}-src"

DESCRIPTION="Monkey Studio is a cross platform Qt 4 IDE"
HOMEPAGE="http://monkeystudio.sourceforge.net/"
SRC_URI="http://monkeystudio.googlecode.com/files/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="|| ( GPL-2 GPL-3 LGPL-3 )"
SLOT="0"
IUSE="doc"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4
	x11-libs/qscintilla"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/qscintilla_headers.patch"
)

S="${WORKDIR}/${MY_P/-src/}/version-${PV/_beta/b}"

src_prepare() {
	#fix Qscintilla include directory. Upstream failed. How odd
	sed -i -e "s/\ \"/\ </" -e "s/\"$/>/" "${S}/qscintilla/sdk/qscintilla.h" \
		|| die "failed to fix qscintilla headers"
	qt4_src_prepare
}

src_configure() {
	eqmake4 build.pro prefix=/usr system_qscintilla=1
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc readme.txt ChangeLog || die "dodoc failed"
}
