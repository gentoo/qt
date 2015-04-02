# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtwebkit/qtwebkit-4.8.6-r1.ebuild,v 1.1 2014/11/15 02:38:53 pesa Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils multibuild multilib python-any-r1 qmake-utils toolchain-funcs multilib-minimal

DESCRIPTION="The WebKit module for the Qt toolkit"
HOMEPAGE="https://www.qt.io/"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="4"
KEYWORDS="~amd64"
IUSE="+gstreamer"

RDEPEND="
	>=dev-db/sqlite-3.8.9:3[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.2-r1:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxslt-1.1.28-r4[${MULTILIB_USEDEP}]
	>=dev-qt/qtcore-4.8.6-r1:4[ssl,${MULTILIB_USEDEP}]
	>=dev-qt/qtdeclarative-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-4.8.6-r2:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtopengl-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtscript-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtsql-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtsvg-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtxmlpatterns-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.11.1-r2[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.5[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.16:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
	virtual/libudev[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.3[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
	gstreamer? (
		>=dev-libs/glib-2.42.2:2[${MULTILIB_USEDEP}]
		>=media-libs/gstreamer-1.4.5:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-base-1.4.5:1.0[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/perl
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
"

src_prepare() {
	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die
	sed -i -e "/QMAKE_CXXFLAGS_RELEASE/d" Source/WTF/WTF.pro Source/JavaScriptCore/Target.pri || die

	epatch "${FILESDIR}"/${PN}-2.3.4-use-correct-typedef.patch
}

multilib_src_compile() {
	# Change the build dir
	# Trick stolen from Fedora 21 SRPM
	export WEBKITOUTPUTDIR="$PWD"

	export QTDIR=/usr/$(get_libdir)/qt4/
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	# --qmake is needed to force the build system to use the qmake
	# compiled for the correct architecture. For example using the amd64
	# qmake to compile the x86 qtwebkit will try to link it against
	# amd64 qt libs, causing the build to fail
	"${S}"/Tools/Scripts/build-webkit \
		--qt --release --no-webkit2 \
		--qmake=$(qt4_get_bindir)/qmake \
		$(use gstreamer || echo --no-video) \
		--makeargs="${MAKEOPTS}" \
		--qmakearg="CONFIG+=production_build CONFIG+=nostrip DEFINES+=HAVE_QTTESTLIB=0" \
		QMAKE_CC=\"$(tc-getCC)\" \
		QMAKE_CFLAGS=\"${CFLAGS}\" \
		QMAKE_CFLAGS_RELEASE=\"\" \
		QMAKE_CXX=\"$(tc-getCXX)\" \
		QMAKE_CXXFLAGS=\"${CXXFLAGS}\" \
		QMAKE_CXXFLAGS_RELEASE=\"\" \
		QMAKE_LINK=\"$(tc-getCXX)\" \
		QMAKE_LFLAGS+=\"${LDFLAGS}\" \
		|| die
}

multilib_src_install() {
	emake INSTALL_ROOT="${D}" install -C Release
}
