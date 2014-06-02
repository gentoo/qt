# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The OpenGL module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE="egl qt3support"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,egl=,qt3support=,${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/opengl
	src/plugins/graphicssystems/opengl"

QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"

src_configure() {
	myconf+="
		-opengl
		$(qt_use qt3support)
		$(qt_use egl)"

	qt4-build-multilib_src_configure
}

src_install() {
	qt4-build-multilib_src_install

	# touch the available graphics systems
	dodir /usr/share/qt4/graphicssystems
	echo "experimental" > "${ED}"/usr/share/qt4/graphicssystems/opengl || die
}
