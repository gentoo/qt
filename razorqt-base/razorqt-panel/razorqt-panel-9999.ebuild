# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils

DESCRIPTION="Razor-qt panel and its plugins"
HOMEPAGE="http://razor-qt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="https://github.com/downloads/Razor-qt/razor-qt/razorqt-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+clock colorpicker cpuload +desktopswitch +mainmenu +mount networkmonitor
	+quicklaunch screensaver sensors +showdesktop +taskbar +tray +volume"

DEPEND="razorqt-base/razorqt-libs
	cpuload? ( sys-libs/libstatgrab )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	volume? ( || ( media-libs/alsa-lib media-sound/pulseaudio ) )"
RDEPEND="${DEPEND}
	razorqt-base/razorqt-data
	mount? ( sys-fs/udisks )"

src_configure() {
	local mycmakeargs=(
		-DSPLIT_BUILD=On
		-DMODULE_PANEL=On
	)
	# probably needs fixing for automagic deps (e.g. alsa / pulse)
	for i in clock colorpicker cpuload desktopswitch mainmenu mount networkmonitor \
			quicklaunch screensaver sensors showdesktop taskbar tray volume; do
		use $i || mycmakeargs+=( -D${i^^}_PLUGIN=No )
	done
	cmake-utils_src_configure
}
