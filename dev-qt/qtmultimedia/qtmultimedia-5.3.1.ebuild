# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Multimedia module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# TODO: opengl, xv

IUSE="alsa gstreamer openal pulseaudio qml widgets"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-bad:0.10
		media-libs/gst-plugins-base:0.10
	)
	openal? ( media-libs/openal )
	pulseaudio? ( media-sound/pulseaudio )
	qml? ( >=dev-qt/qtdeclarative-${PV}:5[debug=] )
	widgets? ( >=dev-qt/qtwidgets-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	use gstreamer  || epatch "${FILESDIR}/${P}-disable-gstreamer.patch"
	use alsa       || sed -i -e '/qtCompileTest(alsa)/d' \
		qtmultimedia.pro || die
	use openal     || sed -i -e '/qtCompileTest(openal)/d' \
		qtmultimedia.pro || die
	use pulseaudio || sed -i -e '/qtCompileTest(pulseaudio)/d' \
		qtmultimedia.pro || die
	qt_use_disable_mod qml quick src/src.pro
	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build_src_prepare
}
