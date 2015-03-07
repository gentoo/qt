# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtwebkit/qtwebkit-4.8.6-r1.ebuild,v 1.1 2014/11/15 02:38:53 pesa Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils multilib python-any-r1 toolchain-funcs

DESCRIPTION="The WebKit module for the Qt toolkit"
HOMEPAGE="https://www.qt.io/ https://qt-project.org/"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/qtwebkit23-2.3.4.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="4"
KEYWORDS="~amd64"

IUSE="+gstreamer"
RDEPEND="
	>=dev-db/sqlite-3.8.3:3
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-qt/qtcore:4[ssl]
	dev-qt/qtdeclarative:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	dev-qt/qtxmlpatterns:4
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	virtual/libudev
	virtual/opengl
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXrender
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
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

src_compile() {
	export QTDIR=/usr/$(get_libdir)/qt4/
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	Tools/Scripts/build-webkit --qt --release --no-webkit2 \
		$(use gstreamer || echo --no-video) \
		--makeargs="${MAKEOPTS}" \
		--qmakearg="CONFIG+=production_build CONFIG+=nostrip" \
		QMAKE_CC=\"$(tc-getCC)\" \
		QMAKE_CXX=\"$(tc-getCXX)\" \
		QMAKE_CFLAGS=\"${CFLAGS}\" \
		QMAKE_CXXFLAGS=\"${CXXFLAGS}\" \
		QMAKE_CFLAGS_RELEASE=\"\" \
		QMAKE_CXXFLAGS_RELEASE=\"\" \
		QMAKE_LFLAGS+=\"${LDFLAGS}\" \
		QMAKE_LINK=\"$(tc-getCXX)\" || die
}

src_install() {
	cd "WebKitBuild/Release" || die
	emake INSTALL_ROOT="${D}" install
}
