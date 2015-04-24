# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 qt5-build

DESCRIPTION="QtWebChannel support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
fi

IUSE=""

DEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtdeclarative-${PV}:5[debug=]
"
RDEPEND="${DEPEND}"
