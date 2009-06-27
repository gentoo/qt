# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

MY_P="${PN}-${PV}-src"

DESCRIPTION="Qt4 application to design electric diagrams"
HOMEPAGE="http://www.qt-apps.org/content/show.php?content=90198"
SRC_URI="http://download.tuxfamily.org/qet/tags/20090627/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-svg:4"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}"/${MY_P}

src_configure(){
	eqmake4
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc CREDIT ChangeLog README || die "dodoc failed"
	if use doc; then
		doxygen Doxyfile
		dohtml -r doc/html/* || die "dohtml failed"
	fi
}
