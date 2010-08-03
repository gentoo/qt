# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/qt-labs/simulator.git"

inherit qt4-r2 git

DESCRIPTION="Qt Simulator"
HOMEPAGE="http://qt.gitorious.org/qt-labs/simulator"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-mobility
	x11-libs/qmf
	x11-libs/qt-simulator"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 QT_NOKIA_SDK_PATH="${S}" \
		QT_MOBILITY_SOURCE_PATH="/usr/include/qt4" \
		QMF_INCLUDEDIR="/usr/include" \
		SIMULATOR_DEPENDENCY_PATH="${S}" *.pro
}
