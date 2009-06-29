# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge subversion

MY_PN=${PN/mp3d/MP3D}
S=${WORKDIR}/${PN}

DESCRIPTION="Qt-based MP3 diagnosis and repair tool"
HOMEPAGE="http://mp3diags.sourceforge.net"
ESVN_REPO_URI="https://mp3diags.svn.sourceforge.net/svnroot/mp3diags"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

DEPEND="x11-libs/qt-gui:4
	dev-libs/boost"
RDEPEND="${DEPENDS}"

src_install() {
	dobin bin/${MY_PN}
	dodoc changelog.txt || die "dodoc failed"

	insinto /usr/share/applications
	doins desktop/${MY_PN}.desktop || die "doins failed"

	local icon_sizes="16 22 24 32 36 48"
	for size in ${icon_sizes}; do
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		newins desktop/${MY_PN}${size}.png ${MY_PN}.png || die "doins failed"
	done

	if use doc; then
		dohtml doc/html/* || die "Failed to install documentation"
	fi
}
