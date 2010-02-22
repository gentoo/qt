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
IUSE="benchmarks dbus debug +demos gconf gstreamer icu plainqt test"

DEPEND="x11-libs/libXfixes
	x11-libs/libXdamage
	>=x11-libs/qt-gui-4.6.0:4
	>=x11-libs/qt-svg-4.6.0:4
	>=x11-libs/qt-opengl-4.6.0:4
	dbus? ( >=x11-libs/qt-dbus-4.6.0:4 )
	gconf? ( gnome-base/gconf )
	gstreamer? ( media-libs/gstreamer:0.10 )
	icu? ( dev-libs/icu )"
RDEPEND="${DEPEND}
	~x11-themes/duitheme-${PV}"

DOCS="README"

use_make() {
	local arg=${2:-$1}

	if use $1; then
		echo "-make ${arg}"
	else
		echo "-nomake ${arg}"
	fi
}

remove_dep() {
	if ! use $1; then
		sed -e "s/\(HAVE_${2}=\)yes/\1no/" -i configure \
			|| die "removing automagic dependency on $1 failed"
	fi
}

src_prepare() {
	qt4-r2_src_prepare
	sed -e "/^\$QMAKE_BIN/d" -i configure \
		|| die "removing qmake call from ./configure failed"

	sed -e "/-Werror/d" \
		-i benchmarks/common_top.pri plainqt/style/style.pro src/src.pro \
		tests/ut_duifeedbackplayer/ut_duifeedbackplayer.pro tests/common_top.pri \
		|| die "removing -Werror failed"

	sed -e "/DUI_LIB_DIR =/s/lib/$(get_libdir)/" \
		-e "/QMAKE_RPATH/d" \
		-i mkspecs/features/dui.prf || die "removing rpath from dui.prf failed"

	sed -e "s/lib/$(get_libdir)/g" -i mkspecs/features/dui_defines.prf.in \
		|| die "sed libdir failed"

	if ! use demos; then
		sed -e '/^DUI_DEFAULT_BUILD_PARTS/s/ demos//' -i configure \
			|| die "removing demos from build failed"
	fi

	remove_dep dbus DBUS
	remove_dep icu ICU
	remove_dep gconf GCONF
	remove_dep gstreamer GSTREAMER
}

src_configure() {
	# custom configure script
	QTDIR=/usr ./configure -release -prefix "/usr" \
		$(use_make benchmarks) \
		$(use_make plainqt) \
		$(use_make test tests) || die "configure failed"

	eqmake4 DUI_BUILD_TREE="${S}"
}
