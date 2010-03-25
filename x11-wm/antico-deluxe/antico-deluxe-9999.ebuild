# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit qt4-r2 subversion

DESCRIPTION="A simple Qt-based window manager with a MacOSX look"
HOMEPAGE="http://v4fproject.wordpress.com/anticodeluxe/"
ESVN_REPO_URI="http://anticodeluxe.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/alsa-lib
	media-libs/libao
	media-libs/libogg
	media-libs/libvorbis
	x11-libs/libxkbfile
	x11-libs/qt-gui:4[dbus]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS BUGS CHANGELOG README ROADMAP"
PATCHES=( "${FILESDIR}/${PN}.pro.patch" )  # patch out stuff that is incomplete

src_prepare() {
	qt4-r2_src_prepare  # dont let subversion.eclass override this
}
