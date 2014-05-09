# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils qt4-r2 cmake-utils

MY_P="${P/_/}"

DESCRIPTION="A graphical user interface for QEMU written in Qt4."
HOMEPAGE="http://qtemu.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qemu"

DEPEND="net-libs/libvncserver
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}
	qemu? ( app-emulation/qemu )"

DOCS=(CHANGELOG README TODO)

S="${WORKDIR}/${MY_P}"
