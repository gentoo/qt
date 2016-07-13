# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit qt5-build

DESCRIPTION="Text-to-speech library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

# TODO: flite plugin (doesn't build)
IUSE=""

RDEPEND="
	app-accessibility/speech-dispatcher
	~dev-qt/qtcore-${PV}
"
DEPEND="${RDEPEND}"
