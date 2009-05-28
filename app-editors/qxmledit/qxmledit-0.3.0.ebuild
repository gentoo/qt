# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge

MY_PN="${PN}-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Qt4 XML Editor"
HOMEPAGE="http://code.google.com/p/qxmledit/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

DOCSDIR="${WORKDIR}/${P}"
DOCS="AUTHORS NEWS README TODO"

S="${WORKDIR}/${P}/src/"

src_prepare(){
	# fix installation path
	sed -i "/^target.path/ s/\/opt\/${PN}/\/usr\/bin/" QXmlEdit.pro || \
		die "failed to fix installation path"
	# fix translations
	sed -i "/^translations.path/ s/\/opt/\/usr\/share/" QXmlEdit.pro || \
		die "failed to fix translations"
	qt4-edge_src_prepare
}
