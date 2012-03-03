# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit qt4-r2

DESCRIPTION="Qt WebKit web browser"
HOMEPAGE="http://www.qupzilla.com/"
SRC_URI="https://github.com/nowrep/QupZilla/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug kde"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-script:4
	x11-libs/qt-sql:4
	x11-libs/qt-webkit:4[dbus]" #TODO: check if dbus is optional
RDEPEND="${DEPEND}"

S="${WORKDIR}/nowrep-QupZilla-c6455f0"

src_configure() {
	if use kde ; then
		KDE=true eqmake4
	else
		eqmake4
	fi
}

# TODO: translation handling
