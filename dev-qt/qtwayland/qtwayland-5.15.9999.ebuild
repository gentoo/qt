# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="vulkan xcomposite"

DEPEND="
	>=dev-libs/wayland-1.6.0
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}[egl,libinput,vulkan=]
	media-libs/mesa[egl]
	>=x11-libs/libxkbcommon-0.2.0
	vulkan? ( dev-util/vulkan-headers )
	xcomposite? (
		x11-libs/libX11
		x11-libs/libXcomposite
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_config vulkan wayland-vulkan-server-buffer \
		src/plugins/hardwareintegration/client/client.pro \
		src/plugins/hardwareintegration/compositor/compositor.pro

	qt5-build_src_prepare
}
