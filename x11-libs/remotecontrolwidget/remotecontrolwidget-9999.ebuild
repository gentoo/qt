# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/qt-labs/${PN}.git
	https://git.gitorious.org/qt-labs/${PN}.git"
EGIT_BRANCH="simulator-master"

inherit multilib qt4-r2 git-2

DESCRIPTION="Remote Control Widget for Qt Simulator"
HOMEPAGE="http://qt.gitorious.org/qt-labs/remotecontrolwidget"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-qt/qtcore-4.7:4
	>=dev-qt/qtgui-4.7:4
	>=dev-qt/qt-mobility-1.2[location]
	>=dev-qt/qtscript-4.7:4
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt4-r2_src_prepare

	sed -i -e '/SUBDIRS/ s/pluginSupport//' \
		${PN}.pro || die

	sed -i -e "s:\(PREFIX =\).*$:\1 ${EPREFIX}/usr:" \
		-e "s:/lib:/$(get_libdir):" \
		library/library.pro || die
}
