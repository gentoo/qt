# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-declarative/qt-declarative-4.6.0.ebuild,v 1.1 2009/12/26 20:49:17 ayoy Exp $

EAPI="2"
EGIT_MASTER="kinetic-animations"
EGIT_BRANCH="kinetic-declarativeui"
EGIT_REPO_URI="git://gitorious.org/+qt-kinetic-developers/qt/kinetic.git"

inherit qt4-r2 git

DESCRIPTION="The Declarative module for the Qt toolkit"
HOMEPAGE="http://qt.nokia.com"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="4"
KEYWORDS=""
IUSE="debug demos examples"

QT_VER="4.6.1"
DEPEND=">=x11-libs/qt-core-${QT_VER}
	>=x11-libs/qt-gui-${QT_VER}
	>=x11-libs/qt-script-${QT_VER}
	>=x11-libs/qt-sql-${QT_VER}
	>=x11-libs/qt-webkit-${QT_VER}
	>=x11-libs/qt-xmlpatterns-${QT_VER}"
RDEPEND="${DEPEND}"

src_prepare() {
	# help qmlviewer and qmldebugger find the freshly compiled Declarative
	# module
	echo "LIBS += -L\"${S}/src/declarative/.obj\"" \
		>> "${S}/tools/qmlviewer/qmlviewer.pro" \
		|| die "fixing LDFLAGS failed"
}

src_configure() {
	eqmake4 src/declarative/declarative.pro -o src/declarative/Makefile

	# running "eqmake4 tools/qmlviewer/qmlviewer.pro"
	# fails with some relative paths not being found
	# so we have to cd
	cd "${S}/tools/qmlviewer"
	eqmake4
}

src_compile() {
	emake -C src/declarative || die "compiling declarative module failed"
	emake -C tools/qmlviewer || die "compiling qmlviewer failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" -C src/declarative install \
		|| die "installing declarative module failed"

	emake INSTALL_ROOT="${D}" -C tools/qmlviewer install \
		|| die "installing qmlviewer failed"

	dodoc README.html || die "dodoc failed"

	for feature in demos examples; do
		if use ${feature}; then
			insinto "/usr/share/${PN}/${feature}"
			doins -r "${feature}/declarative" || die "installing ${feature} failed"
		fi
	done
}
