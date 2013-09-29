# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qttools"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="webkit"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtprintsupport-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	>=dev-qt/qtxml-${PV}:5[debug=]
	webkit? ( >=dev-qt/qtwebkit-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/designer
)

src_prepare() {
	qt5-build_src_prepare

	if ! use webkit; then
		sed -i -e '/qwebview/d' src/designer/src/plugins/plugins.pro || die
	fi
}
