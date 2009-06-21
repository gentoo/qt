# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils qt4-edge

MY_PN="QDiskUsage"
DESCRIPTION="Qt4 Graphical Disk Usage Analyzer"
HOMEPAGE="http://www.qt-apps.org/content/show.php/QDiskUsage?content=107012"
# keep it on my dev space because upstream uses the same tarball name for each
# release
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_PN}"

src_install(){
	dobin ${MY_PN} || die "dobin failed"
	dodoc README || die "dodoc failed"
	make_desktop_entry /usr/bin/${MY_PN} ${MY_PN}
}

pkg_postinst() {
	ewarn "This package is in early development stage, so you can expect problems."
	ewarn "Please read the README in /usr/share/doc/${PF}/"
	ewarn "if you use this package for the first time."
}
