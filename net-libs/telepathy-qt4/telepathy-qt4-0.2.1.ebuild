# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base

DESCRIPTION="Qt4 bindings for the Telepathy D-Bus protocol"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-lang/python
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	econf $(use_enable debug)
}

src_test() {
	dbus-launch emake -j1 check || die "emake check failed"
}
