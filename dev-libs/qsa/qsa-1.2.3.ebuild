# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qsa/qsa-1.1.5.ebuild,v 1.3 2008/07/27 20:15:59 carlo Exp $

EAPI="2"

inherit multilib

DESCRIPTION="Qt Script for Applications"
SRC_URI="ftp://ftp.trolltech.com/${PN}/source/${PN}-x11-opensource-${PV}.tar.gz"
HOMEPAGE="http://www.qtsoftware.com/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug examples editor ide"

DEPEND="<x11-libs/qt-core-4.5.0:4"

S="${WORKDIR}/${PN}-x11-opensource-${PV}"

pkg_setup() {
	# due to sandbox issues, we need to set ${D} in front
	QTDIR="${D}/usr/$(get_libdir)/"
}

src_configure() {
	myconf="${myconf} -prefix /usr"
	! use editor && myconf="${myconf} -no-editor"
	! use ide && myconf="${myconf} -no-ide"
	if use debug; then
		myconf="${myconf} -debug"
	else
		myconf="${myconf} -release"
	fi
	./configure ${myconf} || die "econf failed"
}

src_compile() {
	#fix pre-stripped files before installation
	sed -i "s/strip//" "${S}"/src/qsa/Makefile.qsa
	sed -i "s/--strip-unneeded//" "${S}"/src/qsa/Makefile.qsa
	if use examples; then
		emake sub-examples || die "emake sub-examples failed"
	fi
	emake sub-src || die "emakie sub-src failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" sub-src install || die "emake sub-src-install failed"
	if use examples; then
		emake INSTALL_ROOT="${D}" sub-examples install || die "sub-examples failed"
	fi
}
