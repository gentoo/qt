# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu-qt/libdbusmenu-qt-0.9.3_pre20140619.ebuild,v 1.2 2015/01/30 20:40:55 johu Exp $

EAPI=5

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt4? ( ${CATEGORY}/${PN}:4[debug?,doc?] )
	qt5? ( ${CATEGORY}/${PN}:5[debug?,doc?] )
"
