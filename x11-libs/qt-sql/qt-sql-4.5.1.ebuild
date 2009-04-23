# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-sql/qt-sql-4.5.0.ebuild,v 1.2 2009/03/17 17:52:08 armin76 Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The SQL module for the Qt toolkit"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="firebird +iconv mysql odbc postgres +qt3support +sqlite"

DEPEND="~x11-libs/qt-core-${PV}[debug=,qt3support=]
	firebird? ( dev-db/firebird )
	sqlite? ( dev-db/sqlite:3 )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	odbc? ( dev-db/unixODBC )"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/sql src/plugins/sqldrivers"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/Qt/
include/QtCore/
include/QtSql/
include/QtScript/
src/src.pro
src/corelib/
src/plugins
src/sql
src/3rdparty
src/tools"

pkg_setup() {
	if ! (use firebird || use mysql || use odbc || use postgres || use sqlite); then
		ewarn "You need to enable at least one SQL driver. Enable at least"
		ewarn "one of these USE flags: \"firebird mysql odbc postgres sqlite\""
		die "Enable at least one SQL driver."
	fi

	qt4-build_pkg_setup
}

src_unpack() {
	qt4-build_src_unpack

	sed -e '/pg_config --libs/d' -i "${S}"/configure \
		|| die 'Sed to fix postgresql usage in ./configure failed.'
}

src_configure() {
	# Don't support sqlite2 anymore
	myconf="${myconf} -no-sql-sqlite2
		$(qt_use mysql sql-mysql plugin) $(use mysql && echo "-I/usr/include/mysql -L/usr/$(get_libdir)/mysql ")
		$(qt_use postgres sql-psql plugin) $(use postgres && echo "-I/usr/include/postgresql/pgsql ")
		$(qt_use sqlite sql-sqlite plugin) $(use sqlite && echo '-system-sqlite')
		$(qt_use odbc sql-odbc plugin)
		$(qt_use qt3support)"

	myconf="${myconf} $(qt_use iconv) -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff  -no-accessibility -no-fontconfig
		-no-glib -no-opengl -no-svg -no-gtkstyle"

	qt4-build_src_configure
}
