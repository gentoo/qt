# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

# TODO: directfb, eglfs, evdev, ibus

IUSE="egl +fontconfig gif +glib jpeg opengl +png udev +xcb"

DEPEND="
	media-libs/freetype:2
	sys-libs/zlib
	~x11-libs/qt-core-${PV}[debug=,glib=]
	egl? ( media-libs/mesa[egl] )
	fontconfig? ( media-libs/fontconfig )
	gif? ( media-libs/giflib )
	glib? ( dev-libs/glib:2 )
	jpeg? ( virtual/jpeg )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0 )
	udev? ( sys-fs/udev )
	xcb? (
		x11-libs/libX11
		x11-libs/libXrender
		x11-libs/libxcb
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/platformsupport
	src/plugins/imageformats
	src/plugins/platforms
)

src_configure() {
	local myconf=(
		-accessibility
		$(qt_use egl)
		$(qt_use fontconfig)
		$(use gif || echo -no-gif)
		$(qt_use glib)
		$(qt_use jpeg libjpeg system)
		$(qt_use opengl)
		$(qt_use png libpng system)
		$(use udev || echo -no-libudev)
		$(qt_use xcb)
		-no-eglfs -no-directfb
	)
	qt5-build_src_configure
}
