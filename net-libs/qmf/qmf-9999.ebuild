# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

EGIT_REPO_URI="git://gitorious.org/qt-labs/messagingframework.git"

inherit qt4-r2 git

DESCRIPTION="The Qt Messaging Framework"
HOMEPAGE="http://labs.trolltech.com/page/Projects/QtMessaging"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug examples test"

RDEPEND=">=x11-libs/qt-core-4.6.0
	>=x11-libs/qt-gui-4.6.0
	>=x11-libs/qt-sql-4.6.0
	examples? ( >=x11-libs/qt-webkit-4.6.0 )"
DEPEND="${RDEPEND}
	test? ( >=x11-libs/qt-test-4.6.0 )"

# TODO:
#   qt-gui could be optional
#   doc USE flag (emake docs)
#   implement src_test

DOCS="CHANGES"
PATCHES=(
	# http://bugreports.qt.nokia.com/browse/QTMOBILITY-374
	"${FILESDIR}/${PN}-use-standard-install-paths.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	sed -i -e '/SUBDIRS +=/s:benchmarks::' messagingframework.pro || die

	if ! use examples; then
		sed -i -e '/examples/d' messagingframework.pro || die
	fi

	if ! use test; then
		sed -i -e '/tests/d' messagingframework.pro || die
	else
		echo 'INSTALLS -= target' >> tests/tests.pri
	fi
}
