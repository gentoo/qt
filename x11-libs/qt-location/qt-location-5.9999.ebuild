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

# FIXME: src/3rdparty/poly2tri doesn't respect CXX and CXXFLAGS
# TODO: plugins (qt-jsondb, geoclue, gypsy), qml
IUSE=""

DEPEND="
	~x11-libs/qt-core-${PV}[debug=]
	~x11-libs/qt-gui-${PV}[debug=]
	~x11-libs/qt-network-${PV}[debug=]
	~x11-libs/qt3d-${PV}[debug=]
"
RDEPEND="${DEPEND}"
