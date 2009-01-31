# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4 multilib git

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://trolltech.com/developer/qt-creator"

EGIT_REPO_URI="git://labs.trolltech.com/qt-creator/"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-assistant-4.5.0_beta1
	>=x11-libs/qt-core-4.5.0_beta1[doc]
	>=x11-libs/qt-dbus-4.5.0_beta1
	>=x11-libs/qt-gui-4.5.0_beta1
	>=x11-libs/qt-qt3support-4.5.0_beta1
	>=x11-libs/qt-script-4.5.0_beta1
	>=x11-libs/qt-sql-4.5.0_beta1
	>=x11-libs/qt-svg-4.5.0_beta1
	>=x11-libs/qt-test-4.5.0_beta1
	>=x11-libs/qt-webkit-4.5.0_beta1"

RDEPEND="${DEPEND}
	|| ( media-sound/phonon >=x11-libs/qt-phonon-4.5.0_beta1 )"

src_unpack() {
	git_src_unpack
	epatch ${FILESDIR}/fix_headers_git.patch
}

src_compile() {
	eqmake4 qtcreator.pro || die "eqmake4 failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	make_desktop_entry qtcreator QtCreator designer.png \
		'Qt;Development;GUIDesigner' || die "make_desktop_entry failed"
}
