# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="The 3D module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

# TODO: egl, qml, tools
IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}:5
	~dev-qt/qtgui-${PV}:5
	~dev-qt/qtnetwork-${PV}:5
"
RDEPEND="${DEPEND}"
