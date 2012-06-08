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

IUSE="+glib icu"

DEPEND="
	>=dev-libs/libpcre-8.30[pcre16]
	sys-libs/zlib
	virtual/libiconv
	glib? ( dev-libs/glib:2 )
	icu? ( >=dev-libs/icu-49 )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/tools/qdoc
	src/corelib
	src/concurrent
)

src_configure() {
	local myconf=(
		$(qt_use glib)
		-iconv
		$(qt_use icu)
		-no-accessibility -no-gui -no-cups -no-dbus
		-no-xcb -no-eglfs -no-directfb -no-opengl
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	pushd "${QT5_BUILD_DIR}" >/dev/null || die
	emake INSTALL_ROOT="${D}" install_{qmake,mkspecs}
	popd >/dev/null || die
}
