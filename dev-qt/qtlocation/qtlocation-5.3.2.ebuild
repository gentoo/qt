# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# FIXME: src/3rdparty/poly2tri doesn't respect CXX and CXXFLAGS
# TODO: plugins (geoclue-satellite, gypsy)
IUSE="geoclue qml"

RDEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	geoclue? (
		app-misc/geoclue:0
		dev-libs/glib:2
	)
	qml? (
		>=dev-qt/qtdeclarative-${PV}:5[debug=]
		>=dev-qt/qtnetwork-${PV}:5[debug=]
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	qt_use_compile_test geoclue
	qt_use_disable_mod qml quick \
		src/src.pro

	qt5-build_src_prepare
}
