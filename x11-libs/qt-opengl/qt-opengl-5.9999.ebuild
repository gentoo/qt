# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="egl"

DEPEND="
	virtual/opengl
	~x11-libs/qt-core-${PV}[debug=]
	~x11-libs/qt-gui-${PV}[debug=,egl=,opengl]
	~x11-libs/qt-widgets-${PV}[debug=]
	egl? ( media-libs/mesa[egl] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/opengl
)

src_configure() {
	local myconf=(
		-accessibility
		$(qt_use egl)
		-opengl
	)
	qt5-build_src_configure
}
