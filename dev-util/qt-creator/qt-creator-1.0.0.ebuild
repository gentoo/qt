# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qt-creator/qt-creator-0.9.2_rc1.ebuild,v 1.4 2009/02/25 18:27:24 hwoarang Exp $

EAPI="2"

inherit qt4 multilib

MY_PN="${PN/-/}"
MY_P="${P}-src"

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://trolltech.com/developer/qt-creator"
SRC_URI="http://download.qtsoftware.com/${MY_PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/docs_gen.patch"
}

src_configure() {
	eqmake4 ${MY_PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}/usr" install || die "emake install failed"
	make_desktop_entry qtcreator QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"
}
