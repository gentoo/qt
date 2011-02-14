# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/qgtkstyle/qgtkstyle-4.7.1-r1.ebuild,v 1.2 2010/11/13 20:53:07 wired Exp $

EAPI="3"
inherit confutils qt4-build

DESCRIPTION="Qt style that uses the active GTK theme."
SLOT="4"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEPEND="
	x11-libs/gtk+:2
	>=x11-libs/qt-gui-${PV}-r1
"
DEPEND="${COMMON_DEPEND}
	|| ( >=x11-libs/cairo-1.10.0[-qt4] <x11-libs/cairo-1.10.0 )
"
RDEPEND="${COMMON_DEPEND}
	!>x11-libs/qt-gui-${PV}-r9999
"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/gui
	"

	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools/linguist/phrasebooks
		tools/linguist/shared
		tools/shared"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES} ${QT4_EXTRACT_DIRECTORIES}"

	qt4-build_pkg_setup
}

src_prepare() {
	cp "${FILESDIR}"/qgtkstyle.pro "${S}"/src/gui/gui.pro || die
	cp "${FILESDIR}"/main.cpp "${S}"/src/gui/styles/ || die
	sed "/QT_NO_STYLE_/d" -i "${S}"/src/gui/styles/qgtk* || die
	epatch "${FILESDIR}"/"${PN}"-gentoo.patch
	qt4-build_src_prepare
}

src_configure() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	myconf="${myconf} -qt-gif -system-libpng -system-libjpeg
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2
		-no-sql-odbc -no-xrender -no-xrandr -no-xkb -no-xshape -no-sm -no-svg -no-webkit
		-no-cups -no-glib -no-libmng -no-nis -no-libtiff -no-dbus -no-qdbus -no-egl
		-no-qt3support -no-xinerama -no-phonon -no-opengl -no-accessibility
		-gtkstyle"

	qt4-build_src_configure
}

src_install() {
	insinto /usr/$(get_libdir)/qt4/plugins/styles/ || die
	doins lib/libgtkstyle.so || die
}
