# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Qt4/Qt5 version chooser"
HOMEPAGE="https://qt.gitorious.org/qt/qtchooser"
SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-qt/qttest )"
RDEPEND="!<dev-qt/qtcore-4.8.6:4"

qtchooser_make() {
	emake \
		CXX="$(tc-getCXX)" \
		LFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		"$@"
}

src_compile() {
	qtchooser_make
}

src_test() {
	qtchooser_make check
}

src_install() {
	qtchooser_make INSTALL_ROOT="${D}" install

	keepdir /etc/xdg/qtchooser

	# TODO: bash and zsh completion
	# newbashcomp scripts/${PN}.bash ${PN}
}
