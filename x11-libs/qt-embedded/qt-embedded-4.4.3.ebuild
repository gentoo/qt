# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib

MY_PN="${PN}-linux-opensource-src"

DESCRIPTION="The Qt4 framework for embedded Linux"
HOMEPAGE="http://www.qtsoftware.com/products/device-creation/embedded-linux/"
SRC_URI="ftp://ftp.trolltech.no/qt/source/${MY_PN}-${PV}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="4"
KEYWORDS="-* ~amd64 ~x86"

IUSE="debug doc cups directfb fbcon firebird +glib gif mysql nis ssl pch phonon
	postgres vnc qvfb qt3support sqlite svg svga vnc webkit xmlpatterns"

DEPEND="media-libs/libpng
	virtual/jpeg
	media-libs/libmng
	media-libs/lcms
	sys-libs/zlib
	cups? ( net-print/cups )
	directfb? ( dev-libs/DirectFB )
	firebird? ( dev-db/firebird )
	gif? ( media-libs/giflib )
	mysql? ( virtual/mysql )
	ssl? ( dev-libs/openssl )
	postgres? ( virtual/postgresql-server )
	sqlite? ( dev-db/sqlite )
	svga? ( media-libs/svgalib )
	!x11-libs/qt-assistant:4
	!x11-libs/qt-demo:4
	!x11-libs/qt-core:4
	!x11-libs/qt-dbus:4
	!x11-libs/qt-gui:4
	!x11-libs/qt-phonon:4
	!x11-libs/qt-qt3support:4
	!x11-libs/qt-svg:4
	!x11-libs/qt-sql:4
	!x11-libs/qt-script:4
	!x11-libs/qt-webkit:4
	!x11-libs/qt-xmlpatterns:4"
RDEPEND="${DEPEND}
	qvfb? ( dev-embedded/qvfb )"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	# Set up installation directories
	QTBASEDIR=/usr/$(get_libdir)/qt4
	QTPREFIXDIR=/usr
	QTBINDIR=/usr/bin
	QTLIBDIR=/usr/$(get_libdir)/qt4
	QTPCDIR=/usr/$(get_libdir)/pkgconfig
	QTDATADIR=/usr/share/qt4
	QTDOCDIR=/usr/share/doc/qt-${PV}
	QTHEADERDIR=/usr/include/qt4
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTSYSCONFDIR=/etc/qt4
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTDEMOSDIR=${QTDATADIR}/demos
	PLATFORM=$(qt_mkspecs_dir)
	PATH="${S}/bin:${PATH}"
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"
	ewarn
	ewarn "Qt-embedded is using only a small part of configure options. This"
	ewarn "might not fit your embedded linux setup. In this case, you need "
	ewarn "to add your custom configure options on "myconf" variable. Use"
	ewarn "./configure --help to see all the available options."
	ewarn
}

src_configure() {
	myconf="-prefix ${QTPREFIXDIR}  -bindir ${QTBINDIR}  -libdir ${QTLIBDIR} \
		-docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR} -datadir ${QTDATADIR} \
		-sysconfdir ${QTSYSCONFDIR} -translationdir ${QTTRANSDIR} \
		-examplesdir ${QTEXAMPLESDIR} -demosdir ${QTDEMOSDIR} \
		-plugindir ${QTPLUGINDIR} -confirm-license"
	if use debug; then
		myconf="${myconf} -debug"
	else
		myconf="${myconf} -release"
	fi
	# add qt modules support
	! use qt3support && myconf="${myconf} -no-qt3support"
	! use xmlpatterns && myconf="${myconf} -no-xmlpatterns"
	! use svg && myconf="${myconf} -no-svg"
	! use phonon && myconf="${myconf} -no-phonon"
	! use webkit && myconf="${myconf} -no-webkit"
	! use glib && myconf="${myconf} -no-glib"
	! use gif && myconf="${myconf} -no-gif"
	! use openssl && myconf="${myconf} -no-openssl"
	! use cups && myconf="${myconf} -no-cups"
	! use pch && myconf="${myconf} -no-pch"
	! use nis && myconf="${myconf} -no-nis"
	# Database support
	use firebird && myconf="${myconf} -plugin-sql-ibase" || myconf="${myconf} -no-sql-ibase"
	use mysql && myconf="${myconf} -plugin-sql-mysql" || myconf="${myconf} -no-sql-mysql"
	use postgres && myconf="${myconf} -plugin-sql-psql" || myconf="${myconf} -no-sql-psql"
	use sqlite && myconf="${myconf} -plugin-sql-sqlite" || myconf="${myconf} -no-sql-sqlite"

	# video drivers
	use directfb && myconf="${myconf} -plugin-gfx-directfb" || myconf="${myconf} -no-gfx-directfb"
	use fbcon && myconf="${myconf} -plugin-gfx-linuxfb" || myconf="${myconf} -no-gfx-linuxfb"
	use vnc && myconf="${myconf} -plugin-gfx-vnc" || myconf="${myconf} -no-gfx-qvfb"
	use qvfb && myconf="${myconf} -plugin-gfx-qvfb" || myconf="${myconf} -no-gfx-qvfb"
	use svga && myconf="${myconf} -plugin-gfx-svgalib"
	myconf="${myconf} -plugin-gfx-transformed -qt-gfx-multiscreen"

	# TODO: choose arch (-platform, -xplatform)

	echo ${myconf}
	./configure ${myconf} || die "configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	if use doc; then
		insinto "${QTDOCDIR}" || die "insinto failed"
		doins -r "${S}"/doc/qch || die "doins failed"
		dohtml -r "${S}"/doc/html || die "dohtml failed"
	fi
}
