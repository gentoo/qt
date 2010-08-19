# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

EHG_REPO_URI="http://dev.libqxt.org/libqxt/"

inherit multilib qt4-r2 mercurial

DESCRIPTION="The Qt eXTension library provides cross-platform utility classes for the Qt toolkit"
HOMEPAGE="http://libqxt.org/"
SRC_URI=""

LICENSE="|| ( CPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS=""
IUSE="berkdb crypt debug doc sql web xscreensaver zeroconf"

COMMON_DEPEND="
	x11-libs/libXrandr
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	berkdb? ( >=sys-libs/db-4.6 )
	crypt? (
		>=dev-libs/openssl-0.9.8
		x11-libs/qt-core:4[ssl]
	)
	sql? ( x11-libs/qt-sql:4 )
	web? ( >=dev-libs/fcgi-2.4 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${COMMON_DEPEND}
	doc? ( x11-libs/qt-assistant )
"
RDEPEND="${COMMON_DEPEND}
	xscreensaver? ( x11-libs/libXScrnSaver )
"

S=${WORKDIR}/${PN}

DOCS="AUTHORS CHANGES README"
PATCHES=(
	"${FILESDIR}/${PN}-use-system-qdoc3.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	# eqmake4 disables qmake cache, so we have to use config.pri
	# to store configuration variables instead of .qmake.cache
	sed -i -e '/^QMAKE_CACHE=/s:\.qmake\.cache:config.pri:' configure || die
	sed -i -e '1i include(config.pri)' ${PN}.pro || die
	sed -i -e '1i include(../config.pri)' src/qxtbase.pri || die

	# remove insecure runpath
	sed -i -e '/-Wl,-rpath/d' src/qxtlibs.pri || die
}

src_configure() {
	# custom configure script
	local myconf="./configure
			-prefix '${EPREFIX}/usr'
			-libdir '${EPREFIX}/usr/$(get_libdir)'
			-docdir '${EPREFIX}/usr/share/doc/${PF}'
			-qmake-bin '${EPREFIX}/usr/bin/qmake'
			$(use debug && echo -debug || echo -release)
			$(use berkdb || echo -no-db -nomake berkeley)
			$(use crypt || echo -no-openssl)
			$(use doc || echo -nomake docs)
			$(use sql || echo -nomake sql)
			$(use web || echo -nomake web)
			$(use zeroconf || echo -no-zeroconf -nomake zeroconf)
			-verbose"
	echo ${myconf}
	eval ${myconf} || die "./configure failed"

	eqmake4 -recursive
}

src_compile() {
	qt4-r2_src_compile

	if use doc; then
		einfo "Building documentation"
		emake docs || die
	fi
}

pkg_postinst() {
	if use doc; then
		elog
		elog "In case you want to browse ${PN} documentation using"
		elog "Qt Assistant, perform the following steps:"
		elog "  1. Open the Assistant"
		elog "  2. Edit->Preferences->Documentation->Add"
		elog "  3. Add this path: ${EPREFIX}/usr/share/doc/${PF}/qxt.qch"
		elog
	fi
}
