# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="bindist geolocation +system-ffmpeg +system-icu widgets"

RDEPEND="
	app-arch/snappy
	dev-libs/nss
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtwebchannel-${PV}
	~dev-qt/qtxmlpatterns-${PV}
	dev-libs/jsoncpp
	dev-libs/libevent
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/flac
	media-libs/libwebp
	media-libs/opus
	media-libs/speex
	net-libs/libsrtp
	>=media-libs/libvpx-1.4
	sys-libs/zlib
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXtst
	geolocation? ( ~dev-qt/qtpositioning-${PV} )
	system-ffmpeg? ( media-video/ffmpeg:= )
	system-icu? ( dev-libs/icu:= )
	widgets? ( ~dev-qt/qtwidgets-${PV} )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

src_prepare() {
	qt_use_disable_mod geolocation positionint \
		src/core/core_common.pri \
		src/core/core_gyp_generator.pro
	qt_use_disable_mod widgets widgets \
		src/src.pro \
		tests/quicktestbrowser/quicktestbrowser.pro

	qt5-build_src_prepare
}

src_configure() {
	local myqmakeargs=(
		$(usex bindist '' 'WEBENGINE_CONFIG+="use_proprietary_codecs"')
		$(usex system-ffmpeg 'WEBENGINE_CONFIG+="use_system_ffmpeg"' '')
		$(usex system-icu 'WEBENGINE_CONFIG+="use_system_icu"' '')
	)
	qt5-build_src_configure
}
