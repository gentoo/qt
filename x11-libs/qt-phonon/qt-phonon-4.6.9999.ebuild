# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The Phonon module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="dbus"

DEPEND="~x11-libs/qt-gui-${PV}[debug=,glib,qt3support,qt-copy=]
	!kde-base/phonon-kde
	!kde-base/phonon-xine
	!media-sound/phonon
	media-libs/gstreamer
	media-libs/gst-plugins-base
	dbus? ( =x11-libs/qt-dbus-${PV}[debug=,qt-copy=] )"
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

	qt4-build-edge_src_configure
}
