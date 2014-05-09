# Copyright 1999-2014 Gentoo Foundation
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
	S="${WORKDIR}/razorqt-${PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+alsa +clock colorpicker cpuload +desktopswitch +mainmenu +mount
	networkmonitor pulseaudio +quicklaunch screensaver sensors +showdesktop
	+taskbar +tray +volume"
REQUIRED_USE="volume? ( || ( alsa pulseaudio ) )"

DEPEND="razorqt-base/razorqt-libs
	cpuload? ( sys-libs/libstatgrab )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	volume? ( alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )"
RDEPEND="${DEPEND}
	razorqt-base/razorqt-data
	mount? ( sys-fs/udisks )"

src_configure() {
	local mycmakeargs=(
		-DSPLIT_BUILD=On
		-DMODULE_PANEL=On
	)

	local i
	for i in clock colorpicker cpuload desktopswitch mainmenu mount networkmonitor \
			quicklaunch screensaver sensors showdesktop taskbar tray volume; do
		use $i || mycmakeargs+=( -D${i^^}_PLUGIN=No )
	done

	if use volume; then
		for i in alsa pulseaudio; do
			use $i || mycmakeargs+=( -DVOLUME_USE_${i^^}=No )
		done
	fi
	cmake-utils_src_configure
}
