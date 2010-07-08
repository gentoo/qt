# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EHG_REPO_URI="http://dev.libqxt.org/libqxt/"
inherit eutils qt4 mercurial

DESCRIPTION="The Qt eXTension library provides cross-platform utility classes for the Qt toolkit"
HOMEPAGE="http://libqxt.org/"

LICENSE="|| ( CPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS=""
IUSE="berkdb crypt debug doc sql web"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-script:4
	berkdb? ( x11-libs/qt-sql:4 sys-libs/db )
	sql? ( x11-libs/qt-sql:4 )
	crypt? ( >=dev-libs/openssl-0.9.8 x11-libs/qt-core:4[ssl] )
	web? ( >=dev-libs/fcgi-2.4 )"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )
	net-dns/avahi"

S="${WORKDIR}/${PN}"

src_configure() {
	eqmake4 ${PN}.pro \
		QXT_INSTALL_DOCS="/usr/share/doc/${PF}" \
		QXT_INSTALL_FEATURES="/usr/share/qt4/mkspecs/features"
	local myconf
	myconf="-prefix /usr \
		-libdir /usr/$(get_libdir) \
		-docdir /usr/share/doc/${PF} \
		-qmake-bin /usr/bin/qmake \
		$(use debug && echo -debug) \
		$(use !berkdb && echo -no-db -nomake berkeley) \
		$(use !crypt && echo -nomake crypto -no-openssl) \
		$(use !sql && echo -nomake sql) \
		$(use !web && echo -nomake web)"

	./configure ${myconf} || die "configure failed"
}

src_compile() {
	emake || die "emake failed"
	use doc && emake docs
}

pkg_postinst() {
	if use doc; then
		elog
		elog "In case you want to browse the libqxt documentation using"
		elog "qt-assistant do the following steps:"
		elog "1. Open qt-assistant"
		elog "2. Edit->Preferences->Documentation->Add"
		elog "3. Add this path: /usr/share/doc/${PF}/qxt.qch"
		elog
	fi
}
