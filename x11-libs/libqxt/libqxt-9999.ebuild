# Copyright 1999-2009 Gentoo Foundation
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
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_configure() {
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

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc AUTHORS README

	if use doc; then
		doxygen Doqsyfile
		dohtml -r deploy/docs/*
	fi
}
