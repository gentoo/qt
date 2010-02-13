# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit versionator qt4-r2

MY_P="${PN}-$(get_version_component_range 2)"
DESCRIPTION="A docker application similar to KXDocker"
HOMEPAGE="http://sourceforge.net/projects/xqde/"
SRC_URI="mirror://sourceforge/xqde/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/qt-gui:4[dbus]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
