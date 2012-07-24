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

# TODO: egl, qml, tools
IUSE=""

DEPEND="
	~x11-libs/qt-core-${PV}[debug=]
	~x11-libs/qt-gui-${PV}[debug=,opengl]
	~x11-libs/qt-network-${PV}[debug=]
"
RDEPEND="${DEPEND}"
