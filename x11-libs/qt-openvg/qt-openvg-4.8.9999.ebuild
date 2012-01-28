# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The OpenVG module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWWORDS=""
fi

IUSE="qt3support es2"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,c++0x=,debug=,qpa=,qt3support=]
	~x11-libs/qt-gui-${PV}[aqua=,c++0x=,debug=,egl,qpa=,qt3support=]
	media-libs/mesa[openvg]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/openvg
		src/plugins/graphicssystems/openvg"
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="
			include/QtCore
			include/QtGui
			include/QtOpenVG
			src/corelib
			src/gui
			src/openvg
			src/plugins
			src/3rdparty"
	fi
	QCONFIG_ADD="openvg"
	QCONFIG_DEFINE="QT_OPENVG"

	qt4-build-edge_pkg_setup
}

src_configure() {
	gltype="desktop"

	myconf="${myconf} -openvg -egl
		$(qt_use qt3support)"

	qt4-build-edge_src_configure
}

src_install() {
	qt4-build-edge_src_install

	#touch the available graphics systems
	mkdir -p "${D}/usr/share/qt4/graphicssystems/" || 
		die "could not create ${D}/usr/share/qt4/graphicssystems/"
	touch "${D}/usr/share/qt4/graphicssystems/openvg" ||
		die "could not touch ${D}/usr/share/qt4/graphicssystems/openvg"
}
