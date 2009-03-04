# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge multilib git

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://trolltech.com/developer/qt-creator"

EGIT_REPO_URI="git://labs.trolltech.com/qt-creator/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-assistant-4.5.0_rc1
	>=x11-libs/qt-core-4.5.0_rc1
	>=x11-libs/qt-dbus-4.5.0_rc1
	>=x11-libs/qt-gui-4.5.0_rc1
	>=x11-libs/qt-qt3support-4.5.0_rc1
	>=x11-libs/qt-script-4.5.0_rc1
	>=x11-libs/qt-sql-4.5.0_rc1
	>=x11-libs/qt-svg-4.5.0_rc1
	>=x11-libs/qt-test-4.5.0_rc1
	>=x11-libs/qt-webkit-4.5.0_rc1"

RDEPEND="${DEPEND}
	|| ( media-sound/phonon >=x11-libs/qt-phonon-4.5.0_rc1 )"

PATCHES=(
	"${FILESDIR}/docs_gen.patch"
)

src_configure() {
	eqmake4 qtcreator.pro || die "eqmake4 failed"
}

src_install() {
	emake INSTALL_ROOT="${D}/usr" install || die "emake install failed"
	make_desktop_entry qtcreator QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"
}
