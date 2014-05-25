# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt desktop panel and plugins"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+alsa +clock colorpicker cpuload +desktopswitch +kbindicator +mainmenu
	+mount networkmonitor pulseaudio +quicklaunch screensaver sensors
	+showdesktop sysstat +taskbar +tray +volume worldclock"
REQUIRED_USE="volume? ( || ( alsa pulseaudio ) )"

DEPEND="lxqt-base/liblxqt
	lxqt-base/liblxqt-mount
	razorqt-base/libqtxdg
	lxqt-base/libsysstat
	lxqt-base/lxqt-globalkeys
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	x11-libs/libX11
	cpuload? ( sys-libs/libstatgrab )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	sysstat? ( lxqt-base/libsysstat )
	volume? ( alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )
	worldclock? ( dev-libs/icu:= )"
RDEPEND="${DEPEND}
	lxde-base/lxmenu-data"

src_configure() {
	local mycmakeargs i y
	for i in clock colorpicker cpuload desktopswitch kbindicator mainmenu mount \
		networkmonitor quicklaunch screensaver sensors showdesktop sysstat \
		taskbar tray volume worldclock; do
		y=$(tr '[:lower:]' '[:upper:]' <<< "${i}")
		mycmakeargs+=( $(cmake-utils_use ${i} ${y}_PLUGIN) )
	done

	if use volume; then
		mycmakeargs+=( $(cmake-utils_use alsa VOLUME_USE_ALSA)
			$(cmake-utils_use pulseaudio VOLUME_USE_PULSEAUDIO) )
	fi

	cmake-utils_src_configure
}
