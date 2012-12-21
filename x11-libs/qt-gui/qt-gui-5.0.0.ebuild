# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

# TODO: directfb, linuxfb, ibus
# FIXME: at-spi2 no longer needed since 5.0.0_beta2

IUSE="+accessibility egl eglfs evdev gif gles2 +glib jpeg kms opengl +png udev +xcb"
REQUIRED_USE="
	egl? ( gles2 )
	eglfs? ( egl evdev )
	gles2? ( opengl )
	kms? ( egl )
"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype:2
	sys-libs/zlib
	~x11-libs/qt-core-${PV}[debug=,glib=]
	egl? ( media-libs/mesa[egl] )
	gif? ( media-libs/giflib )
	gles2? ( || (
		media-libs/mesa[gles2]
		media-libs/mesa[gles]
	) )
	glib? ( dev-libs/glib:2 )
	jpeg? ( virtual/jpeg )
	kms? (
		media-libs/mesa[gbm]
		virtual/udev
		x11-libs/libdrm
	)
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0 )
	udev? ( virtual/udev )
	xcb? (
		>=x11-libs/libX11-1.5
		>=x11-libs/libXi-1.6
		x11-libs/libXrender
		>=x11-libs/libxcb-1.8.1
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
		accessibility? (
			app-accessibility/at-spi2-core
			~x11-libs/qt-dbus-${PV}[debug=]
		)
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	test? ( ~x11-libs/qt-network-${PV}[debug=] )
"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/platformsupport
	src/plugins/imageformats
	src/plugins/platforms
)

pkg_setup() {
	QCONFIG_ADD="
		$(usev accessibility)
		$(usev egl)
		$(usev eglfs)
		$(usev evdev)
		fontconfig
		$(use gles2 && echo opengles2)
		$(usev kms)
		$(usev opengl)
		$(use udev && echo libudev)
		$(usev xcb)"

	QCONFIG_DEFINE="$(use egl && echo QT_EGL)
			$(use eglfs && echo QT_EGLFS)
			$(use jpeg && echo QT_IMAGEFORMAT_JPEG)"

	qt5-build_pkg_setup
}

src_configure() {
	local dbus="-no-dbus"
	if use accessibility && use xcb; then
		dbus="-dbus"
	fi

	local opengl="-no-opengl"
	if use gles2; then
		opengl="-opengl es2"
	elif use opengl; then
		opengl="-opengl desktop"
	fi

	local myconf=(
		$(qt_use accessibility)
		${dbus}
		$(qt_use egl)
		$(qt_use eglfs)
		$(qt_use evdev)
		-fontconfig
		$(use gif || echo -no-gif)
		$(qt_use glib)
		$(qt_use jpeg libjpeg system)
		$(qt_use kms)
		${opengl}
		$(qt_use png libpng system)
		$(use udev || echo -no-libudev)
		$(use xcb && echo -xcb -xrender)
	)
	qt5-build_src_configure
}
