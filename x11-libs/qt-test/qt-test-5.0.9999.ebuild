# Copyright 1999-2012 Gentoo Foundation
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

IUSE=""

RDEPEND="
	~x11-libs/qt-core-${PV}[debug=]
"
DEPEND="${RDEPEND}
	test? (
		~x11-libs/qt-gui-${PV}[debug=]
		~x11-libs/qt-xml-${PV}[debug=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/testlib
)
