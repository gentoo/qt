# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge subversion

MY_PN="QChartDiary"

DESCRIPTION="Free Qt4 diary/agenda application"
HOMEPAGE="http://qt-apps.org/content/show.php?content=99294"
ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake4 ${MY_PN}.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc AUTHORS CHANGELOG README || die "dodoc failed"
}
