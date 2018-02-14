# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Qt module to make WebGL-like 3D drawing calls from Qt Quick JavaScript"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
"
RDEPEND="${DEPEND}"
