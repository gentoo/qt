# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils qt4 subversion

DESCRIPTION="The Qt eXTension library provides cross-platform utility classes for the Qt toolkit"
HOMEPAGE="http://libqxt.org/"
ESVN_REPO_URI="svn://libqxt.org/svn/libqxt/trunk"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS=""
IUSE="berkdb crypt debug doc sql web"

RDEPEND="|| ( ( x11-libs/qt-gui:4
		x11-libs/qt-script:4
		berkdb? ( x11-libs/qt-sql:4 )
		sql? ( x11-libs/qt-sql:4 ) )
	=x11-libs/qt-4.3*:4[png] )
	berkdb? ( sys-libs/db )
	crypt? ( >=dev-libs/openssl-0.9.8
		|| ( x11-libs/qt-core:4[ssl] =x11-libs/qt-4.3*:4[ssl] ) )
	web? ( >=dev-libs/fcgi-2.4 )"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )"

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

src_compile() {
	# parallel compilation fails, bug #194730
	emake -j1 || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc AUTHORS README

	if use doc; then
		doxygen Doqsyfile
		dohtml -r deploy/docs/*
	fi
}
