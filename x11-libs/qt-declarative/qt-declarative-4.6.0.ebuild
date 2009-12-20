# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

MY_P="qt-${PV}${PN#qt}"

DESCRIPTION="The Declarative module for the Qt toolkit"
HOMEPAGE="http://qt.nokia.com"
SRC_URI="http://get.qt.nokia.com/qml/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug demos examples"

DEPEND="~x11-libs/qt-core-${PV}
	~x11-libs/qt-gui-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-webkit-${PV}
	~x11-libs/qt-xmlpatterns-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# help qmlviewer and qmldebugger find the freshly compiled Declarative module
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
