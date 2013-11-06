# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXDE-Qt desktop panel and plugins"
HOMEPAGE="http://www.lxde.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/lxde/${PN}.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+alsa +clock colorpicker cpuload +desktopswitch +kbindicator +mainmenu
	+mount networkmonitor pulseaudio +quicklaunch screensaver sensors
	+showdesktop sysstat +taskbar +tray +volume worldclock"
REQUIRED_USE="volume? ( || ( alsa pulseaudio ) )"

DEPEND="lxde-base/liblxqt
	lxde-base/liblxqt-mount
	lxde-base/libqtxdg
	lxde-base/lxqt-globalkeys
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	cpuload? ( sys-libs/libstatgrab )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	volume? ( alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )
	worldclock? ( dev-libs/icu )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs
	for i in clock colorpicker cpuload desktopswitch kbindicator mainmenu mount \
		networkmonitor quicklaunch screensaver sensors showdesktop sysstat \
		taskbar tray volume worldclock; do
		mycmakeargs+=( $(cmake-utils_use $i ${i^^}_PLUGIN) )
	done
	if use volume; then
		mycmakeargs+=( $(cmake-utils_use alsa VOLUME_USE_ALSA)
			$(cmake-utils_use pulseaudio VOLUME_USE_PULSEAUDIO) )
	fi
	cmake-utils_src_configure
}
