# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Physical position determination library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

DEPEND="
	=dev-qt/qtbase-${PV}*
	=dev-qt/qtdeclarative-${PV}*
"
RDEPEND="${DEPEND}"
