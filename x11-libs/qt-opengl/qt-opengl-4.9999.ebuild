# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The OpenGL module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWORDS=""
fi

IUSE="egl qt3support"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-gui-${PV}[aqua=,c++0x=,qpa=,debug=,egl=,qt3support=]
	virtual/opengl"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/opengl
		src/plugins/graphicssystems/opengl"
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="
			include/QtCore
			include/QtGui
			include/QtOpenGL
			src/corelib
			src/gui
			src/opengl
			src/plugins
			src/3rdparty"
	fi

	QCONFIG_ADD="opengl"
	QCONFIG_DEFINE="QT_OPENGL $(use egl && echo QT_EGL)"
	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -opengl
		$(qt_use qt3support)
		$(qt_use egl)"

	qt4-build-edge_src_configure

	# Not building tools/designer/src/plugins/tools/view3d as it's
	# commented out of the build in the source
}

src_install() {
	qt4-build-edge_src_install

	#touch the available graphics systems
	mkdir -p "${D}/usr/share/qt4/graphicssystems/" || 
		die "could not create ${D}/usr/share/qt4/graphicssystems/"
	touch "${D}/usr/share/qt4/graphicssystems/opengl" ||
		die "could not touch ${D}/usr/share/qt4/graphicssystems/opengl"
}
