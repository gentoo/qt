# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt5-module

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE=""

# yep, qt-core is a build-time dep only
RDEPEND=""
DEPEND="${RDEPEND}
	~x11-libs/qt-core-${PV}[debug=]
	test? ( ~x11-libs/qt-gui-${PV}[debug=] )
"

src_configure() {
	# TODO: v8snapshot
	echo "QT_CONFIG -= v8snapshot" >> "${QT5_BUILD_DIR}"/.qmake.cache

	qt5-module_src_configure
}
