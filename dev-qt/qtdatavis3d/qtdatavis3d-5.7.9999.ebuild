# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit qt5-build

DESCRIPTION="OpenGL data visualisation module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="gles2 examples"

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}[gles2=]
	~dev-qt/qtgui-${PV}[gles2=]
	examples? ( ~dev-qt/qtwidgets-${PV} )
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtwidgets-${PV} )
"

QT5_TARGET_SUBDIRS+=(src)

pkg_setup() {
	use examples && QT5_TARGET_SUBDIRS+=(examples)
}
