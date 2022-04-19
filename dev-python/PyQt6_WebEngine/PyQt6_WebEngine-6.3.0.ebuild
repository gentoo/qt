# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 flag-o-matic multiprocessing qmake-utils

QT_PV="6.3:6" # minimum tested qt version

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug quick +widgets"

DEPEND="
	>=dev-python/PyQt6-${QT_PV%:*}[gui,ssl,${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	>=dev-qt/qtwebengine-${QT_PV}[widgets]
	quick? ( dev-python/PyQt6[qml] )
	widgets? ( dev-python/PyQt6[network,printsupport,webchannel,widgets] )"
RDEPEND="
	${DEPEND}
	>=dev-python/PyQt6_sip-13.2[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/PyQt-builder-1.11[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	sys-devel/gcc"

src_prepare() {
	default

	# qmake needs real g++ (not clang), but at least respect ${CHOST} #726112
	mkdir "${T}"/cxx || die
	ln -s "$(type -P ${CHOST}-g++ || type -P g++ || die)" "${T}"/cxx/g++ || die
	PATH=${T}/cxx:${PATH}
}

src_configure() {
	append-cxxflags -std=c++17 # needed with clang / older gcc

	DISTUTILS_ARGS=(
		--jobs=$(makeopts_jobs)
		--qmake="$(qt6_get_bindir)"/qmake6
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose

		--enable=QtWebEngineCore
		$(usex quick --{enable,disable}=QtWebEngineQuick)
		$(usex widgets --{enable,disable}=QtWebEngineWidgets)

		$(usev debug '--debug --qml-debug --tracing')
	)
}
