# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cvs qt4 eutils

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

#src_prepare() {
#	sed -i "s/build_all/build_all dll/" \
#		"${S}"/qtermwidget_patches/qtermwidget_pro.patch

#	cd "${WORKDIR}"/qtermwidget
#	epatch "${S}"/qtermwidget_patches/qtermwidget_pro.patch
#}

src_compile() {
	eqmake4 || die "eqmake4 failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "install failed"

	newicon src/icons/main.png qterminal.png
	make_desktop_entry qterminal QTerminal qterminal "System;TerminalEmulator"

	dodoc AUTHORS README TODO
	docinto qtermwidget
	dodoc "${WORKDIR}"/qtermwidget/{AUTHORS,README,TODO}
}
