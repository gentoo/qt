# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The Phonon module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE="dbus qt3support"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=,qt3support=]
	!kde-base/phonon-kde
	!kde-base/phonon-xine
	!media-libs/phonon
	!media-sound/phonon
	aqua? ( ~dev-qt/qtopengl-${PV}[aqua,debug=,qt3support=] )
	!aqua? (
		media-libs/gstreamer:0.10
		media-plugins/gst-plugins-meta:0.10
	)
	dbus? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/phonon
	src/plugins/phonon"

QCONFIG_ADD="phonon"

pkg_setup() {
	QCONFIG_DEFINE="QT_PHONON
		$(use aqua || echo QT_GSTREAMER)"
}

src_configure() {
	myconf+="
		-phonon -phonon-backend
		-no-opengl -no-svg
		$(qt_use dbus qdbus)
		$(qt_use qt3support)"

	qt4-build-multilib_src_configure
}
