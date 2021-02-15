# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="SQL abstraction library for the Qt5 framework"
SLOT=5/$(ver_cut 1-3) # bug 639140

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="freetds mariadb mysql oci8 odbc postgres +sqlite"

REQUIRED_USE="
	|| ( freetds mariadb mysql oci8 odbc postgres sqlite )
	?? ( mariadb mysql )
"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
	freetds? ( dev-db/freetds )
	mariadb? ( dev-db/mariadb-connector-c:= )
	mysql? ( dev-db/mysql-connector-c:= )
	oci8? ( dev-db/oracle-instantclient:=[sdk] )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/sql
	src/plugins/sqldrivers
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:sql
)

PATCHES=( "${FILESDIR}/${PN}-5.15.2-mysql-use-pkgconfig.patch" )

src_prepare() {
	qt5-build_src_prepare
	if use mariadb; then
		sed -e "/type.*pkgConfig.*mysqlclient/s/mysqlclient/libmariadb/" \
		-i src/plugins/sqldrivers/configure.json || die
	fi
}

src_configure() {
	local myconf=(
		$(qt_use freetds  sql-tds    plugin)
		$(qt_use oci8     sql-oci    plugin)
		$(qt_use odbc     sql-odbc   plugin)
		$(qt_use postgres sql-psql   plugin)
		$(qt_use sqlite   sql-sqlite plugin)
		$(usex sqlite -system-sqlite '')
	)

	if use mariadb || use mysql; then
		myconf+=( -plugin-sql-mysql )
	fi

	use oci8 && myconf+=("-I${ORACLE_HOME}/include" "-L${ORACLE_HOME}/$(get_libdir)")

	qt5-build_src_configure
}
