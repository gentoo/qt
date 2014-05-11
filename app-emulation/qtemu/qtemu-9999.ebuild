# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils qt4-r2 cmake-utils subversion

DESCRIPTION="A graphical user interface for QEMU written in Qt4"
HOMEPAGE="http://qtemu.sourceforge.net/"
ESVN_REPO_URI="http://qtemu.svn.sourceforge.net/svnroot/qtemu/trunk/qtemu"

LICENSE="GPL-2 LGPL-2.1 CC-BY-3.0"
SLOT="0"
KEYWORDS=""
IUSE="qemu"

DEPEND="net-libs/libvncserver
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}
	qemu? ( app-emulation/qemu )"

DOCS=(CHANGELOG README TODO)
