# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="egl gles2"

DEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	~dev-qt/qtgui-${PV}[debug=,egl=,opengl]
	~dev-qt/qtwidgets-${PV}[debug=]
	virtual/opengl
	egl? ( media-libs/mesa[egl] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/opengl
)
pkg_setup() {
	QCONFIG_ADD+="opengl
		$(use egl && echo egl)
		$(use gles2 && echo opengles2)"
	QCONFIG_DEFINE+="QT_OPENGL
		$(use gles2 && echo QT_OPENGLES2)"
}

src_configure() {
	local myconf=(
		$(qt_use egl)
		-opengl $(use gles2 && echo es2)
	)
	qt5-build_src_configure
}
