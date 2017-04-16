# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu-qt/libdbusmenu-qt-0.9.3_pre20140619.ebuild,v 1.2 2015/01/30 20:40:55 johu Exp $

EAPI=5

EBZR_REPO_URI="lp:libdbusmenu-qt"

[[ ${PV} == 9999* ]] && BZR_ECLASS="bzr"
inherit cmake-utils virtualx ${BZR_ECLASS}

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
if [[ ${PV} == 9999* ]] ; then
	KEYWORDS=""
else
	MY_PV=${PV/_pre/+14.10.}
	SRC_URI="http://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"
	# upstream has no permissions to use some kde written code so repack git
	# repo every time
	#SRC_URI="http://dev.gentoo.org/~scarabeus/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
	PATCHES=( "${FILESDIR}/${P}-optionaltests.patch" )
fi

LICENSE="LGPL-2"
SLOT="5"
IUSE="debug doc"
S=${WORKDIR}/${PN}-${MY_PV}

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		dev-libs/qjson
		dev-qt/qttest:5
	)
"

DOCS=( NEWS README )

# tests fail due to missing connection to dbus
RESTRICT="test"

src_prepare() {
	[[ ${PV} == 9999* ]] && bzr_src_prepare
	cmake-utils_src_prepare

	use test || comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with doc)
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}

src_test() {
	local builddir=${BUILD_DIR}

	BUILD_DIR=${BUILD_DIR}/tests \
		VIRTUALX_COMMAND=cmake-utils_src_test virtualmake

	BUILD_DIR=${builddir}
}
