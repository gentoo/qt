# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit python-any-r1 qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

# TODO: qtprintsupport, qttestlib, geolocation, orientation/sensors
# FIXME: tons of automagic deps

IUSE="+accessibility gstreamer libxml2 multimedia opengl qml udev webp widgets xslt"

RDEPEND="
	dev-db/sqlite
	media-libs/fontconfig
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	~x11-libs/qt-core-${PV}[debug=,icu]
	~x11-libs/qt-gui-${PV}[accessibility=,debug=]
	~x11-libs/qt-network-${PV}[debug=]
	~x11-libs/qt-sql-${PV}[debug=]
	gstreamer? (
		dev-libs/glib:2
		>=media-libs/gstreamer-0.10.30:0.10
		>=media-libs/gst-plugins-base-0.10.30:0.10
	)
	libxml2? ( dev-libs/libxml2 )
	multimedia? ( ~x11-libs/qt-multimedia-${PV}[debug=] )
	opengl? ( ~x11-libs/qt-opengl-${PV}[debug=] )
	qml? ( ~x11-libs/qt-declarative-${PV}[debug=] )
	udev? ( virtual/udev )
	webp? ( media-libs/libwebp )
	widgets? ( ~x11-libs/qt-widgets-${PV}[accessibility=,debug=] )
	xslt? (
		libxml2? ( dev-libs/libxslt )
		!libxml2? ( ~x11-libs/qt-xmlpatterns-${PV}[debug=] )
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	sys-devel/bison
	sys-devel/flex
"

pkg_setup() {
	python-any-r1_pkg_setup
	qt5-build_pkg_setup
}
