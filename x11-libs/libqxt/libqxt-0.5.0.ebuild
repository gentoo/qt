# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libqxt/libqxt-0.5.0.ebuild,v 1.1 2009/04/30 13:26:15 yngwin Exp $

EAPI=2
inherit eutils qt4

DESCRIPTION="The Qt eXTension library provides cross-platform utility classes for the Qt toolkit"
HOMEPAGE="http://libqxt.org/"
SRC_URI="http://bitbucket.org/${PN}/${PN}/downloads/${P}.tgz"

LICENSE="|| ( CPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb crypt debug doc sql web"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-script:4
	berkdb? ( x11-libs/qt-sql:4 sys-libs/db )
	sql? ( x11-libs/qt-sql:4 )
	crypt? ( >=dev-libs/openssl-0.9.8 x11-libs/qt-core:4[ssl] )
	web? ( >=dev-libs/fcgi-2.4 )"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc4.4.patch
}

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
	# fix pre-striped files issue
	for i in $(ls "${S}"/src); do
		sed -i "s/qxtbuild/nostrip\ qxtbuild/" "${S}"/src/${i}/${i}.pro
	done
	./configure ${myconf} || die "configure failed"
}

#src_compile() {
#	# parallel compilation fails, bug #194730
#	emake -j1 || die "make failed"
#}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc {AUTHORS,README,LICENSE,cpl1.0.txt}

	if use doc; then
		doxygen Doqsyfile
		dohtml -r deploy/docs/*
	fi
}
