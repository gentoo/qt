# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge git

DESCRIPTION="A simple Qt4/X11 window manager"
HOMEPAGE="http://www.antico.netsons.org/"
EGIT_REPO_URI="git://github.com/antico/antico.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="x11-libs/qt-gui:4[dbus]"
DEPEND="${RDEPEND}"

src_prepare() {
	if ! use debug; then
		einfo "Removing debug flags..."
		sed -i -e "s:debug:release:" \
			-e "s://DEFINES:DEFINES:" \
			antico.pro || die "sed failed"
	fi
}

src_install() {
	dodir /usr/share/${P}
	exeinto /usr/share/${P}
	doexe antico || die "Installing antico binary failed"

	insinto /usr/share/${P}
	doins -r theme || die "Installing default theme failed"
	dodoc README CHANGELOG || die "dodoc failed"

	insinto /usr/share/xsessions
	newins antico-kdm.desktop antico.desktop || die "Installing desktop file failed"

	echo "#!/bin/bash" > antico.sh
	echo "pushd /usr/share/${P}" >> antico.sh
	echo "./antico" >> antico.sh
	echo "popd" >> antico.sh
	newbin antico.sh antico || die "Installing antico wrapper script failed"
}
