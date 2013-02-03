# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="cups"

RDEPEND="
	~x11-libs/qt-core-${PV}[debug=]
	~x11-libs/qt-gui-${PV}[debug=]
	~x11-libs/qt-widgets-${PV}[debug=]
	cups? ( net-print/cups )
"
DEPEND="${RDEPEND}
	test? ( ~x11-libs/qt-network-${PV}[debug=] )
"

QT5_TARGET_SUBDIRS=(
	src/printsupport
	src/plugins/printsupport
)

pkg_setup() {
	QCONFIG_ADD="$(usev cups)"

	qt5-build_pkg_setup
}

src_configure() {
	local myconf=(
		$(qt_use cups)
	)
	qt5-build_src_configure
}
