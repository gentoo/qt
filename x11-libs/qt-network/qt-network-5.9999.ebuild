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

IUSE="connman networkmanager +ssl"

DEPEND="
	sys-libs/zlib
	~x11-libs/qt-core-${PV}[debug=]
	connman? ( ~x11-libs/qt-dbus-${PV}[debug=] )
	networkmanager? ( ~x11-libs/qt-dbus-${PV}[debug=] )
	ssl? ( dev-libs/openssl:0 )
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

QT5_TARGET_SUBDIRS=(
	src/network
	src/plugins/bearer/generic
)

pkg_setup() {
	qt5-build_pkg_setup

	use connman && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/connman)
	use networkmanager && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/networkmanager)
}

src_configure() {
	local myconf=(
		$(use connman || use networkmanager && echo -dbus-linked || echo -no-dbus)
		$(use ssl && echo -openssl-linked || echo -no-openssl)
		-no-xcb -no-eglfs -no-directfb
	)
	qt5-build_src_configure
}
