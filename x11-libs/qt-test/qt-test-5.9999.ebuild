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
	~x11-libs/qt-core-${PV}[debug=]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/testlib
)

src_configure() {
	local myconf=(
		-no-accessibility -no-gui -no-cups -no-dbus
		-no-xcb -no-eglfs -no-directfb -no-opengl
	)
	qt5-build_src_configure
}
