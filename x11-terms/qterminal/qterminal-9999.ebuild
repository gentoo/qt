# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cvs qt4-edge

DESCRIPTION="Qt4-based multitab terminal emulator"
HOMEPAGE="http://qterminal.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	ECVS_SERVER="qtermwidget.cvs.sourceforge.net:/cvsroot/qtermwidget"
	ECVS_MODULE="qtermwidget"
	cvs_src_unpack

	ECVS_SERVER="qterminal.cvs.sourceforge.net:/cvsroot/qterminal"
	ECVS_MODULE="qterminal"
	cvs_src_unpack
}

src_prepare() {
	qt4-edge_src_prepare
	echo "CONFIG += ordered" >> qterminal.pro
}

src_install() {
	qt4-edge_src_install

	newicon src/icons/main.png qterminal.png || die
	make_desktop_entry qterminal QTerminal qterminal \
			"Qt;System;TerminalEmulator" || die

	dodoc AUTHORS || die
	docinto qtermwidget
	dodoc "${WORKDIR}"/qtermwidget/{AUTHORS,Changelog,README} || die
}
