# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-panel/lxqt-panel-0.7.0-r1.ebuild,v 1.3 2014/05/29 18:01:43 jauhien Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt desktop panel and plugins"
HOMEPAGE="http://www.lxqt.org/"

SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"
IUSE="+alsa +clock colorpicker cpuload +desktopswitch dom +kbindicator +mainmenu
	+mount networkmonitor pulseaudio +quicklaunch screensaver sensors
	+showdesktop +taskbar teatime +tray +volume worldclock"

REQUIRED_USE="volume? ( || ( alsa pulseaudio ) )"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	>=lxde-base/menu-cache-1.0.0_rc1
	>=lxqt-base/liblxqt-0.8.0
	>=lxqt-base/liblxqt-mount-0.8.0
	>=lxqt-base/lxqt-globalkeys-0.8.0
	>=razorqt-base/libqtxdg-1.0.0
	x11-libs/libX11
	cpuload? ( sys-libs/libstatgrab )
	mount? ( lxqt-base/liblxqt-mount[udisks] )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	volume? ( alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )
	worldclock? ( dev-libs/icu:= )"
RDEPEND="${DEPEND}
	lxde-base/lxmenu-data"

src_configure() {
	local mycmakeargs i y
	for i in clock colorpicker cpuload desktopswitch dom kbindicator mainmenu mount \
		networkmonitor quicklaunch screensaver sensors showdesktop \
		taskbar teatime tray volume worldclock; do
		y=$(tr '[:lower:]' '[:upper:]' <<< "${i}")
		mycmakeargs+=( $(cmake-utils_use ${i} ${y}_PLUGIN) )
	done

	if use volume; then
		mycmakeargs+=( $(cmake-utils_use alsa VOLUME_USE_ALSA)
			$(cmake-utils_use pulseaudio VOLUME_USE_PULSEAUDIO) )
	fi
	mycmakeargs+=(
		-DUSE_QT5=ON
		-DSYSSTAT_PLUGIN=OFF
	)
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman panel/man/*.1
}
