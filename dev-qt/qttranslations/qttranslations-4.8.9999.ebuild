# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="Translation files for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="translations"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	src
	tools"

src_configure() {
	cd translations || die
	"${QT4_BINDIR}"/qmake || die
}

src_compile() {
	emake -C translations
}
