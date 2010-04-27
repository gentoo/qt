# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 git multilib toolchain-funcs

DESCRIPTION="The Harmattan Application Framework library"
HOMEPAGE="http://duiframework.wordpress.com"
EGIT_REPO_URI="git://gitorious.org/maemo-6-ui-framework/libdui.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="benchmarks dbus debug +demos gconf gstreamer icu pch plainqt test"

COMMON_DEPEND="
	x11-libs/libXfixes
	x11-libs/libXdamage
	>=x11-libs/qt-gui-4.6.0:4
	>=x11-libs/qt-svg-4.6.0:4
	>=x11-libs/qt-opengl-4.6.0:4
	dbus? ( >=x11-libs/qt-dbus-4.6.0:4 )
	gconf? ( gnome-base/gconf )
	gstreamer? ( media-libs/gstreamer:0.10 )
	icu? ( dev-libs/icu )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	~x11-themes/duitheme-${PV}"

PATCHES=( "${FILESDIR}/remove-automagic-deps.patch" )
DOCS="README"

use_make() {
	local arg=${2:-$1}

	if use $1; then
		echo "-make ${arg}"
	else
		echo "-nomake ${arg}"
	fi
}

enable_feature() {
	local arg=${2:-$1}

	if use $1; then
		sed -e "s/^\(HAVE_${arg}=\).*/\1yes/" -i configure \
			|| die "enabling $1 failed"
	fi
}

src_prepare() {
	qt4-r2_src_prepare
	sed -e "/^\$QMAKE_BIN/d" \
		-i configure \
		|| die "removing qmake call from ./configure failed"

	sed -e "s/-Werror//" \
		-i benchmarks/common_top.pri \
		-i src/common_top.pri \
		-i tests/common_top.pri \
		|| die "removing -Werror failed"

	sed -e "/M_LIB_DIR =/s/lib/$(get_libdir)/" \
		-e "/QMAKE_RPATH/d" \
		-i mkspecs/features/meegotouch.prf \
		|| die "removing rpath from meegotouch.prf failed"

	if ! use demos; then
		sed -e '/^M_DEFAULT_BUILD_PARTS/s/ demos//' -i configure \
			|| die "removing demos from build failed"
	fi

	sed -e "s/^\(CFG_.*\)auto/\1no/" -i configure \
		|| die "removing automagic dependencies failed"
}

src_configure() {
	enable_feature dbus DBUS
	enable_feature icu ICU
	enable_feature gconf GCONF
	enable_feature gstreamer GSTREAMER

	# custom configure script
	QTDIR=/usr ./configure -release \
	    -prefix "/usr" \
		-libdir "/usr/$(get_libdir)" \
		$(use_make benchmarks) \
		$(use_make plainqt) \
		$(use_make test tests) || die "configure failed"

	eqmake4 M_BUILD_TREE="${S}" M_SOURCE_TREE="${S}"
}
