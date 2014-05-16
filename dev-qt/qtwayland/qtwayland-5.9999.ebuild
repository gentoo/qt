# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="Wayland plugin for Qt"
HOMEPAGE="http://qt-project.org/wiki/QtWayland"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="qml wayland-compositor"

DEPEND="
	>=dev-libs/wayland-1.3.0
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=,egl,opengl]
	qml? ( >=dev-qt/qtdeclarative-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"

src_configure() {
	if use wayland-compositor; then
		echo "CONFIG += wayland-compositor" >> "${QT5_BUILD_DIR}"/.qmake.cache
	fi
	qt5-build_src_configure
}
