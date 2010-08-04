# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

EGIT_REPO_URI="git://gitorious.org/qt-labs/messagingframework.git"

inherit multilib qt4-r2 git

DESCRIPTION="The Qt Messaging Framework"
HOMEPAGE="http://labs.trolltech.com/blogs/2009/09/21/introducing-qmf-an-advanced-mobile-messaging-framework/"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/qt-core-4.6.0
	>=x11-libs/qt-gui-4.6.0
	>=x11-libs/qt-sql-4.6.0
	>=x11-libs/qt-test-4.6.0"
RDEPEND="${DEPEND}"

# TODO:
#   qt-gui should be optional
#   qt-test is only needed for unit tests
#   automagic dep on qt-webkit, see examples/qtmail/plugins/viewers/generic/generic.pro

DOCS="CHANGES"
PATCHES=(
	"${FILESDIR}/${PN}-use-standard-install-paths.patch"
)

src_prepare() {
	qt4-r2_src_prepare
}
