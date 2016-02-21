# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib qt4-r2 git-r3

DESCRIPTION="Qt4 Connman Applet"
HOMEPAGE="https://bitbucket.org/devonit/qconnman"
EGIT_REPO_URI="https://bitbucket.org/devonit/${PN}.git"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""

### TODO: add static-libs and qt5 support
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	net-misc/connman
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS README"

src_configure() {
	eqmake4 \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="$(get_libdir)"
}
