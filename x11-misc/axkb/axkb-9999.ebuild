# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge git

MY_PN="AXKB"

DESCRIPTION="Qt4 application to adjust layouts by xkb"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Antico+XKB?content=101667"
EGIT_REPO_URI="git://github.com/disels/axkb.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake4 ${MY_PN}.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc NEWS README TODO || die "dodoc failed"
}
