# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/qt-labs/messagingframework.git"
EGIT_BRANCH="master"

inherit qt4-r2 git multilib

DESCRIPTION="The Qt Messaging Framework"
HOMEPAGE="labs.trolltech.com/blogs/2009/09/21/introducing-qmf-an-advanced-mobile-messaging-framework/"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/qt-core-4.6.0
	>=x11-libs/qt-gui-4.6.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix rpath
	sed -e "/QMAKE_LFLAGS/d" \
		-e "/-Wl,-rpath/d" \
		-e "s#QMF_INSTALL_ROOT#QMF_INSTALL_ROOT/share/${PN}#" \
		-i "benchmarks/tst_messageserver/tst_messageserver.pro" || die
	sed -e "/QMAKE_LFLAGS/d" \
		-i "tests/tests.pri" || die
	
	# Fix install location
	for f in $(find "src/plugins/" | grep \.pro); do
		sed -e "s#QMF_INSTALL_ROOT#QMF_INSTALL_ROOT/share/${PN}#" -i ${f} || die
	done
	for f in $(find "examples/" | grep \.pro); do
		sed -e "s#QMF_INSTALL_ROOT#QMF_INSTALL_ROOT/share/${PN}#" -i ${f} || die
	done

	sed -e "s#QMF_INSTALL_ROOT#QMF_INSTALL_ROOT/share/${PN}#" \
		-i "tests/tests.pri" \
		-i "tests/tst_python_email/tst_python_email.pro" || die
	#multilib-strict support for amd64
	for x in messageserver qtopiamail; do
		sed -i "/target.path/s:lib:$(get_libdir):" \
			src/libraries/$x/$x.pro
	done
}

src_install() {
	emake INSTALL_ROOT="${D}/usr" DESTDIR="${D}/usr" install || die "emake install failed"
}
