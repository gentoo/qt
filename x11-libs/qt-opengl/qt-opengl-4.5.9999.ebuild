# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The OpenGL module for the Qt toolkit."
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS=""
IUSE="+qt3support"

DEPEND="~x11-libs/qt-core-${PV}[qt3support=,qt-copy=]
	~x11-libs/qt-gui-${PV}[qt3support=,qt-copy=]
	virtual/opengl
	virtual/glu"

QT4_TARGET_DIRECTORIES="src/opengl"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}"

QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"

src_configure() {
	myconf="${myconf} -opengl
		$(qt_use qt3support)"
	# Not building tools/designer/src/plugins/tools/view3d as it's commented out of the build in the source
	qt4-build-edge_src_configure
}
