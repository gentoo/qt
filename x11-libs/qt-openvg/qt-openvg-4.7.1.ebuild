# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build

DESCRIPTION="The OpenVG module for the Qt toolkit"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="egl qt3support es2"

DEPEND="~x11-libs/qt-core-${PV}[debug=,qt3support=]
	~x11-libs/qt-gui-${PV}[debug=,egl,qt3support=]
	virtual/opengl"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/openvg
		src/plugins/graphicssystems/openvg"

	QT4_EXTRACT_DIRECTORIES="
		include/QtCore
		include/QtGui
		include/QtOpenVG
		src/corelib
		src/gui
		src/openvg
		src/plugins
		src/3rdparty"

	QCONFIG_ADD="openvg"
	QCONFIG_DEFINE="QT_OPENVG"

	qt4-build_pkg_setup
}

src_configure() {
	gltype="desktop"

	myconf="${myconf} -openvg
		$(qt_use qt3support)
		$(qt_use egl)"

	qt4-build_src_configure
}
