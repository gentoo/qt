# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="An advanced, easy-to-use, and fast desktop environment based on Qt"
HOMEPAGE="http://razor-qt.org"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="0.4.1"
	KEYWORDS=""
else
	SRC_URI="http://razor-qt.org/install/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc policykit"

COMMON_DEPEND="policykit? ( sys-auth/polkit-qt )
	x11-libs/libXcomposite
	x11-libs/libXdamage
	>=x11-libs/qt-core-4.6.0
	>=x11-libs/qt-dbus-4.6.0
	>=x11-libs/qt-gui-4.6.0
	>=x11-libs/qt-script-4.6.0"

DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	dev-util/cmake"

RDEPEND="${COMMON_DEPEND}
	|| (
		x11-wm/openbox
		kde-base/kwin
		x11-wm/metacity
		xfce-base/xfwm4
		x11-wm/enlightenment
		x11-wm/fvwm
		x11-wm/sawfish
		x11-wm/windowmaker
		)"

src_compile() {
	cmake-utils_src_make

	# build developer documentation using Doxygen
	use doc && emake -C "${CMAKE_BUILD_DIR}" docs
}

src_install() {
	cmake-utils_src_install

	# install developer documentation
	use doc && dodoc -r "${CMAKE_BUILD_DIR}/docs"
}

pkg_postinst() {
	einfo "To be able to Shutdown/Reboot from Razor,"
	einfo "make sure sys-power/upower is installed."
	einfo "For the Removable Media plugin to work,"
	einfo "make sure sys-fs/udisks is installed."
}

