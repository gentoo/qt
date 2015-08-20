# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit subversion

DESCRIPTION="A YouTube downloader and converter"
HOMEPAGE="http://sourceforge.net/projects/elltube"

ESVN_REPO_URI="http://elltube.svn.sourceforge.net/svnroot/elltube/trunk/"
ESVN_PROJECT="elltube"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-lang/python-2.4
	dev-python/PyQt4
	media-video/ffmpeg
"

src_compile() {
	# just pass since make does nasty stuff :)
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc CHANGELOG
}
