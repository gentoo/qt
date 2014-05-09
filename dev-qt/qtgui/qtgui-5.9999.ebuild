# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

# TODO: directfb, linuxfb, offscreen

IUSE="accessibility eglfs evdev gif gles2 +glib harfbuzz ibus jpeg kms opengl +png udev +xcb"
REQUIRED_USE="
	eglfs? ( evdev gles2 )
	gles2? ( opengl )
	kms? ( evdev gles2 )
"

RDEPEND="
	~dev-qt/qtcore-${PV}[debug=,glib=]
	media-libs/fontconfig
	media-libs/freetype:2
	sys-libs/zlib
	gif? ( media-libs/giflib )
	gles2? ( || (
		media-libs/mesa[egl,gles2]
		media-libs/mesa[egl,gles]
	) )
	glib? ( dev-libs/glib:2 )
	harfbuzz? ( >=media-libs/harfbuzz-0.9.12:0= )
	ibus? ( ~dev-qt/qtdbus-${PV}[debug=] )
	jpeg? ( virtual/jpeg:0 )
	kms? (
		media-libs/mesa[gbm]
		virtual/udev
		x11-libs/libdrm
	)
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0= )
	udev? ( virtual/udev )
	xcb? (
		x11-libs/libICE
		x11-libs/libSM
		>=x11-libs/libX11-1.5
		>=x11-libs/libXi-1.6
		x11-libs/libXrender
		>=x11-libs/libxcb-1.10[xkb]
		>=x11-libs/libxkbcommon-0.4.1
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
		accessibility? ( ~dev-qt/qtdbus-${PV}[debug=] )
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	test? ( ~dev-qt/qtnetwork-${PV}[debug=] )
"
PDEPEND="
	ibus? ( app-i18n/ibus )
"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/platformsupport
	src/plugins/imageformats
	src/plugins/platforminputcontexts/compose
	src/plugins/platforms
)

pkg_setup() {
	QCONFIG_ADD=(
		$(use accessibility && echo accessibility-atspi-bridge)
		$(usev eglfs)
		$(usev evdev)
		fontconfig
		$(use gles2 && echo egl opengles2)
		$(use harfbuzz && echo system-harfbuzz)
		$(usev kms)
		$(usev opengl)
		$(use udev && echo libudev)
		$(usev xcb)
	)
	QCONFIG_DEFINE=(
		$(use accessibility && echo QT_ACCESSIBILITY_ATSPI_BRIDGE || echo QT_NO_ACCESSIBILITY_ATSPI_BRIDGE)
		$(use eglfs	|| echo QT_NO_EGLFS)
		$(use gles2	&& echo QT_OPENGL_ES QT_OPENGL_ES_2 || echo QT_NO_EGL)
		$(use jpeg	|| echo QT_NO_IMAGEFORMAT_JPEG)
		$(use opengl	|| echo QT_NO_OPENGL)
		$(use png	|| echo QT_NO_IMAGEFORMAT_PNG)
	)

	use ibus && QT5_TARGET_SUBDIRS+=(src/plugins/platforminputcontexts/ibus)
	use opengl && QT5_TARGET_SUBDIRS+=(src/openglextensions)

	qt5-build_pkg_setup
}

src_configure() {
	local dbus="-no-dbus"
	if use accessibility && use xcb; then
		dbus="-dbus"
	fi

	local gl="-no-egl -no-opengl"
	if use gles2; then
		gl="-egl -opengl es2"
	elif use opengl; then
		gl="-no-egl -opengl desktop"
	fi

	local myconf=(
		${dbus}
		$(qt_use eglfs)
		$(qt_use evdev)
		-fontconfig
		-system-freetype
		$(use gif || echo -no-gif)
		${gl}
		$(qt_use glib)
		$(qt_use harfbuzz harfbuzz system)
		$(qt_use jpeg libjpeg system)
		$(qt_use kms)
		$(qt_use png libpng system)
		$(use udev || echo -no-libudev)
		$(use xcb && echo -xcb -xrender -sm)
	)
	qt5-build_src_configure
}
