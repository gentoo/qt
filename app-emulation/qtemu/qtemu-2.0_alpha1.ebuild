# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4-edge cmake-utils

MY_P="${P/_/}"

DESCRIPTION="A graphical user interface for QEMU written in Qt4."
HOMEPAGE="http://qtemu.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CCPL-Attribution-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kvm +qemu"

DEPEND="net-libs/libvncserver
	x11-libs/qt-gui:4
	x11-libs/qt-webkit:4"
RDEPEND="${DEPEND}
	qemu? ( app-emulation/qemu )
	kvm? ( app-emulation/kvm )"

DOCS=(CHANGELOG README TODO)

S="${WORKDIR}/${MY_P}"
