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

IUSE="scripttools"

DEPEND="
	~x11-libs/qt-core-${PV}[debug=]
	scripttools? (
		~x11-libs/qt-gui-${PV}[debug=]
		~x11-libs/qt-widgets-${PV}[debug=]
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt5-build_src_prepare

	use scripttools || sed -i -e '/scripttools/d' \
		src/src.pro || die
}
