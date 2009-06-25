# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-phonon/qt-phonon-4.5.1.ebuild,v 1.7 2009/06/08 22:41:08 jer Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Phonon module for the Qt toolkit"
SLOT="4"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ~ppc64 x86 ~x86-fbsd"
IUSE="+dbus"

DEPEND="~x11-libs/qt-gui-${PV}[debug=,glib,qt3support]
	!kde-base/phonon-kde
	!kde-base/phonon-xine
	!media-sound/phonon
	media-libs/gstreamer
	media-libs/gst-plugins-base
	dbus? ( =x11-libs/qt-dbus-${PV}[debug=] )"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
src/phonon
src/plugins/phonon"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/
src"

QCONFIG_ADD="phonon"
QCONFIG_DEFINE="QT_GSTREAMER"

src_configure() {
	myconf="${myconf} -phonon -no-opengl -no-svg
		$(qt_use dbus qdbus)"

	qt4-build_src_configure
}

# bug 265586
src_install() {
	qt4-build_src_install
	insinto ${QTHEADERDIR}
	doins -r "${S}"/include/Phonon || die "failed to install Phonon headers"
}
