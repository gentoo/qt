# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 git multilib

DESCRIPTION="The Harmattan window compositor/manager"
HOMEPAGE="http://duiframework.wordpress.com"
EGIT_REPO_URI="git://gitorious.org/maemo-6-ui-framework/duicompositor.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~x11-libs/libdui-${PV}
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	>=x11-libs/qt-gui-4.6.0:4
	>=x11-libs/qt-opengl-4.6.0:4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s:/usr/lib:/usr/$(get_libdir):" \
		-i decorators/libdecorator/libdecorator.pro \
		|| die "sed libdir failed"
}
