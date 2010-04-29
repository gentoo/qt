# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The OpenGL module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="egl qt3support"

DEPEND="~x11-libs/qt-core-${PV}[debug=,qt3support=,stable-branch=]
	~x11-libs/qt-gui-${PV}[debug=,egl=,qt3support=,stable-branch=]
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
src/opengl
src/plugins/graphicssystems/opengl"

QT4_EXTRACT_DIRECTORIES="
include/QtCore
include/QtGui
include/QtOpenGL
src/corelib
src/gui
src/opengl
src/plugins
src/3rdparty"

QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"

PATCHES=(
	"${FILESDIR}/qtbug-9691-egl.patch"
	"${FILESDIR}/qtbug-9691-Xdefs.patch"
)

src_configure() {
	myconf="${myconf} -opengl
		$(qt_use egl)
		$(qt_use qt3support)"

	qt4-build-edge_src_configure

	# Not building tools/designer/src/plugins/tools/view3d as it's
	# commented out of the build in the source
}
