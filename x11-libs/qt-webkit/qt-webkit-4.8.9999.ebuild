# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-webkit/qt-webkit-4.7.4.ebuild,v 1.1 2011/09/08 09:22:47 wired Exp $

EAPI="4"
if [[ ${PV} == 4*9999 ]]; then
    QT_ECLASS="-edge"
fi
inherit qt4-build${QT_ECLASS}

DESCRIPTION="The Webkit module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWORDS=""
fi
IUSE="+gstreamer +jit"

DEPEND="
	dev-db/sqlite:3
	~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=,ssl]
	~x11-libs/qt-gui-${PV}[aqua=,c++0x=,qpa=,dbus?,debug=]
	~x11-libs/qt-xmlpatterns-${PV}[aqua=,c++0x=,qpa=,debug=]
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)"
RDEPEND="${DEPEND}"

if [[ ${PV} != 4*9999 ]]; then
	PATCHES=( "${FILESDIR}/${P}-c++0x-fix.patch" )
fi

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/3rdparty/webkit/Source/JavaScriptCore/
		src/3rdparty/webkit/Source/WebCore/
		src/3rdparty/webkit/Source/WebKit/qt/
		tools/designer/src/plugins/qwebview"
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="
			include/
			src/
			tools/"
	fi

	QCONFIG_ADD="webkit"
	QCONFIG_DEFINE="QT_WEBKIT"

	qt4-build${QT_ECLASS}_pkg_setup
}

src_prepare() {
	[[ $(tc-arch) == "ppc64" ]] && append-flags -mminimal-toc #241900
	use c++0x && append-flags -fpermissive
	sed -i -e '/QMAKE_CXXFLAGS[[:blank:]]*+=/s:-Werror::g' \
			src/3rdparty/webkit/Source/WebKit.pri || die
	qt4-build${QT_ECLASS}_src_prepare
}

src_configure() {
	# won't build with gcc 4.6 without this for now
	myconf="${myconf}
			-webkit -system-sqlite
			$(qt_use jit javascript-jit)
			-DENABLE_VIDEO=$(use gstreamer && echo 1 || echo 0)
			-D GST_DISABLE_DEPRECATED"
	qt4-build${QT_ECLASS}_src_configure
}
