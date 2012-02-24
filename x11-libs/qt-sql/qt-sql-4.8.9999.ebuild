# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
if [[ ${PV} == 4*9999 ]]; then
	QT_ECLASS="-edge"
fi

inherit qt4-build${QT_ECLASS}

DESCRIPTION="The SQL module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWORDS=""
fi
IUSE="firebird freetds mysql odbc postgres qt3support +sqlite"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	firebird? ( dev-db/firebird )
	freetds? ( dev-db/freetds )
	mysql? ( virtual/mysql )
	odbc? ( || ( dev-db/unixODBC dev-db/libiodbc ) )
	postgres? ( dev-db/postgresql-base )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
	src/sql
	src/plugins/sqldrivers"

	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/Qt/
		include/QtCore/
		include/QtSql/
		src/src.pro
		src/corelib/
		src/plugins
		src/tools/tools.pro"
	fi

	if ! (use firebird || use freetds || use mysql || use odbc || use postgres || use sqlite ); then
		ewarn "You need to enable at least one SQL driver. Enable at least"
		ewarn "one of these USE flags: \"firebird freetds mysql odbc postgres sqlite \""
		die "Enable at least one SQL driver."
	fi

	qt4-build${QT_ECLASS}_pkg_setup
}

src_configure() {
	myconf+="
		$(qt_use firebird sql-ibase plugin)
		$(qt_use freetds sql-tds plugin)
		$(qt_use mysql sql-mysql plugin) $(use mysql && echo "-I${EPREFIX}/usr/include/mysql -L${EPREFIX}/usr/$(get_libdir)/mysql")
		$(qt_use odbc sql-odbc plugin) $(use odbc && echo "-I${EPREFIX}/usr/include/iodbc")
		$(qt_use postgres sql-psql plugin) $(use postgres && echo "-I${EPREFIX}/usr/include/postgresql/pgsql")
		$(qt_use sqlite sql-sqlite plugin) $(use sqlite && echo -system-sqlite)
		-no-sql-db2
		-no-sql-oci
		-no-sql-sqlite2
		-no-sql-symsql
		$(qt_use qt3support)
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg -no-openssl
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		-no-glib"

	qt4-build${QT_ECLASS}_src_configure
}
