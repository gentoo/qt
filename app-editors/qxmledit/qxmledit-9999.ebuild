# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 subversion

DESCRIPTION="Qt4 XML Editor"
HOMEPAGE="http://code.google.com/p/qxmledit/"
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README TODO )
DOCSDIR="${WORKDIR}/${P}"

src_prepare(){
	subversion_src_prepare
	# fix installation path
	sed -i "/^target.path/ s/\/opt\/${PN}/\/usr\/bin/" src/QXmlEdit.pro || \
		die "failed to fix installation path"
	# fix translations
	sed -i "/^translations.path/ s/\/opt/\/usr\/share/" src/QXmlEdit.pro || \
		die "failed to fix translations"
	qt4-r2_src_prepare
}

src_install(){
	qt4-r2_src_install
	newicon "${S}"/src/images/icon.png ${PN}.png
	make_desktop_entry QXmlEdit QXmlEdit ${PN} "Qt;Utility;TextEditor;"
}
