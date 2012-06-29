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

IUSE=""

DEPEND="
	sys-apps/dbus
	sys-libs/zlib
	~x11-libs/qt-core-${PV}[debug=]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/qdbusxml2cpp
	src/tools/qdbuscpp2xml
	src/dbus
)
QCONFIG_ADD="dbus"

src_configure() {
	local myconf=(
		-dbus-linked
		-no-xcb -no-eglfs -no-directfb
	)
	qt5-build_src_configure
}
