# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="connman networkmanager"

DEPEND="
	~x11-libs/qt-core-${PV}[debug=]
	connman? ( ~x11-libs/qt-dbus-${PV}[debug=] )
	networkmanager? ( ~x11-libs/qt-dbus-${PV}[debug=] )
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

QT5_TARGET_SUBDIRS=(
	src/plugins/bearer/generic
)

pkg_setup() {
	qt5-build_pkg_setup

	use connman && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/connman)
	use networkmanager && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/networkmanager)
}

src_configure() {
	local myconf=(
		-no-accessibility -no-gui -no-cups
		-no-xcb -no-eglfs -no-directfb -no-opengl
	)

	if use connman || use networkmanager; then
		myconf+=(-dbus-linked)
	else
		myconf+=(-no-dbus)
	fi

	qt5-build_src_configure
}
