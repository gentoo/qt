# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-edge versionator subversion

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Download (and convert) videos from various Web Video Services"
HOMEPAGE="http://xviservicethief.sourceforge.net/"
ESVN_REPO_URI="http://xviservicethief.svn.sourceforge.net/svnroot/xviservicethief/trunk/"
# Note: all released versions are labelled alpha

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-arch/unzip
	x11-libs/qt-gui:4"
RDEPEND="x11-libs/qt-gui:4
	media-video/ffmpeg"

PATCHES=( "${FILESDIR}/gcc-4.3.patch" )

S="${WORKDIR}"

# TODO: translations, documentation

src_configure() {
	eqmake4 xVideoServiceThief.pro
}

src_install() {
	dobin bin/xvst || die "dobin failed"
	dodoc changelog.txt || die "dodoc failed"
	insinto /usr/share/pixmaps/
	newins resources/images/InformationLogo.png xvst.png || die "newins failed"
	make_desktop_entry /usr/bin/xvst xVideoServiceThief xvst 'Qt;AudioVideo;Video' \
		|| die "make_desktop_entry failed"
}
