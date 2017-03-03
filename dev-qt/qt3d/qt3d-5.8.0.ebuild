# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="The 3D module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

# TODO: gamepad, tools
IUSE="gles2"

DEPEND="
	~dev-qt/qtconcurrent-${PV}
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}[gles2=]
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	>=media-libs/assimp-3.1.1
"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -r src/3rdparty/assimp/{code,contrib,include} || die

	qt5-build_src_prepare
}
