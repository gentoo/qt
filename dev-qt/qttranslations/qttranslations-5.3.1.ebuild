# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="Translation files for the Qt5 toolkit"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND="
	>=dev-qt/linguist-tools-${PV}:5
	>=dev-qt/qtcore-${PV}:5[debug=]
"
RDEPEND="${DEPEND}"
