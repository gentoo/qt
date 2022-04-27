# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

DEPEND="
	dev-libs/wayland
	=dev-qt/qtbase-${PV}*[gui,opengl]
	=dev-qt/qtdeclarative-${PV}*
	media-libs/libglvnd
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
