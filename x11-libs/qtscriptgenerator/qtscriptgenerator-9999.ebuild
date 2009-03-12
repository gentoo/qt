# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib qt4-edge git

DESCRIPTION="Tool for generating Qt bindings for Qt Script"
HOMEPAGE="http://code.google.com/p/qtscriptgenerator/"
EGIT_REPO_URI="git://labs.trolltech.com/qtscriptgenerator"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-dbus-4.5.0
	>=x11-libs/qt-gui-4.5.0
	>=x11-libs/qt-opengl-4.5.0
	|| ( >=x11-libs/qt-phonon-4.5.0 media-sound/phonon )
	>=x11-libs/qt-script-4.5.0
	>=x11-libs/qt-sql-4.5.0
	>=x11-libs/qt-svg-4.5.0
	>=x11-libs/qt-xmlpatterns-4.5.0"
RDEPEND="${RDEPEND}"

pkg_setup(){
	QTDIR="/usr/include/qt4"
	QTLIBDIR="/usr/$(get_libdir)/qt4/"
}

src_configure() {
	cd "${S}"/generator
	eqmake4 generator.pro
	cd "${S}"/qtbindings
	eqmake4 qtbindings.pro
}

src_compile() {
	cd "${S}"/generator
	emake || die "emake generator failed"
	./generator --include-paths="/usr/include/qt4" 	|| die "running generator failed"
	cd "${S}"/qtbindings
	make || die "make qtbindings failed" # TODO: fix emake
}

src_install() {
	insinto "${QTLIBDIR}"/plugins/script/
	doins -r "${S}"/plugins/script/* || die "installing libraries failed"
}
		
