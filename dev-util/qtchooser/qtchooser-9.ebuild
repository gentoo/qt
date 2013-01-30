# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

MY_P=${P}-g8f08405

DESCRIPTION="Qt4/Qt5 version chooser"
HOMEPAGE="http://macieira.org/qtchooser/"
SRC_URI="http://macieira.org/qtchooser/${MY_P}.tar.gz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( x11-libs/qt-test )"
RDEPEND="!x11-libs/qt-core:4" # FIXME

S=${WORKDIR}/${MY_P}

src_compile() {
	emake CXX="$(tc-getCXX)" LFLAGS="${LDFLAGS}"
}

src_test() {
	emake CXX="$(tc-getCXX)" LFLAGS="${LDFLAGS}" check
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
