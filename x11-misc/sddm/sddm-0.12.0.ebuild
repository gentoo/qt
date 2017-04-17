# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="consolekit pam systemd"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb(-)]
	consolekit? ( >=sys-auth/consolekit-0.9.4 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.7.0
	virtual/pkgconfig"

src_prepare() {
	cmake-utils_src_prepare

	epatch "${FILESDIR}/${P}-respect-user-flags.patch"
	use consolekit && epatch "${FILESDIR}/${PN}-0.10.0-consolekit.patch"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		)

	cmake-utils_src_configure
}

pkg_postinst() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/sddm ${PN} video
}
