# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qttools"

inherit qt5-build

DESCRIPTION="Graphical tool for translating Qt applications"

IUSE="+gui"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtxml-${PV}:5[debug=]
	gui? ( >=dev-qt/qtwidgets-${PV}:5[debug=]
		>=dev-qt/qtgui-${PV}:5[debug=]
		>=dev-qt/qtprintsupport-${PV}:5[debug=]
		>=dev-qt/designer-${PV}:5[debug=] )

"
RDEPEND="${DEPEND}"


QT5_TARGET_SUBDIRS=(
	src/linguist
)

src_configure() {
	if ! use gui; then
		echo "CONFIG += no-png" >> "${QT5_BUILD_DIR}"/.qmake.cache
	fi
	qt5-build_src_configure
}
