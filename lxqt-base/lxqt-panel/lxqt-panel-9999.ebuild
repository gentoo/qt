# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt desktop panel and plugins"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"
IUSE="+alsa +clock colorpicker cpuload +desktopswitch dom +kbindicator +mainmenu
	+mount networkmonitor pulseaudio +qt4 qt5 +quicklaunch screensaver sensors
	+showdesktop sysstat +taskbar teatime +tray +volume worldclock"
REQUIRED_USE="volume? ( || ( alsa pulseaudio ) )
			^^ ( qt4 qt5 )"

DEPEND="
	qt4? ( 
		~razorqt-base/libqtxdg-${PV}[qtmimetypes]
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
	)
	qt5? (
		~razorqt-base/libqtxdg-${PV}[qt5]
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
	)
	>=lxde-base/menu-cache-0.3.3
	~lxqt-base/liblxqt-${PV}
	~lxqt-base/liblxqt-mount-${PV}
	~lxqt-base/libsysstat-${PV}
	~lxqt-base/lxqt-globalkeys-${PV}
	x11-libs/libX11
	cpuload? ( sys-libs/libstatgrab )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	sysstat? ( ~lxqt-base/libsysstat-${PV} )
	volume? ( alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )
	worldclock? ( dev-libs/icu:= )"
RDEPEND="${DEPEND}
	~lxde-base/lxmenu-data-${PV}"

src_configure() {
	local mycmakeargs i y
	for i in clock colorpicker cpuload desktopswitch dom kbindicator mainmenu mount \
		networkmonitor quicklaunch screensaver sensors showdesktop sysstat \
		taskbar teatime tray volume worldclock; do
		y=$(tr '[:lower:]' '[:upper:]' <<< "${i}")
		mycmakeargs+=( $(cmake-utils_use ${i} ${y}_PLUGIN) )
	done

	if use volume; then
		mycmakeargs+=( $(cmake-utils_use alsa VOLUME_USE_ALSA)
			$(cmake-utils_use pulseaudio VOLUME_USE_PULSEAUDIO) )
	fi

	if use qt5; then
		mycamkeargs+=( $(cmake-utils_use_use qt5 QT5) )
	fi

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman panel/man/*.1
}
