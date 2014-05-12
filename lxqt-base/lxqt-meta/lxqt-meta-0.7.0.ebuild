# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxde-meta/lxde-meta-0.5.5-r4.ebuild,v 1.2 2014/03/16 13:20:58 hwoarang Exp $

EAPI=5

inherit readme.gentoo

DESCRIPTION="Meta ebuild for LXQT, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal sddm upower"

DOC_CONTENTS="
	For your convenience you can review the LXDE Configuration HOWTO at
	http://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"

RDEPEND="
	sddm? ( x11-misc/sddm )
	~lxqt-base/lxqt-qtplugin-${PV}
	~lxqt-base/lxqt-openssh-askpass-${PV}
	!minimal? (
		x11-wm/openbox
		>=x11-misc/obconf-qt-0.1.0 )
	~lxqt-base/lxqt-notificationd-${PV}
	upower? (
		~lxqt-base/lxqt-runner-${PV}
		~lxqt-base/lxqt-policykit-${PV}
		~lxqt-base/lxqt-powermanagement-${PV} )
	~lxqt-base/lxqt-about-${PV}
	~lxqt-base/lxqt-config-${PV}
	~lxqt-base/lxqt-config-randr-${PV}
	>=lxde-base/lxde-icon-theme-0.5
	~lxqt-base/lxqt-common-${PV}
	>=lxde-base/lxmenu-data-0.5.1
	~lxqt-base/lxqt-panel-${PV}
	~lxqt-base/lxqt-session-${PV}
	~x11-misc/pcmanfm-qt-${PV}"

pkg_postinst() {
	readme.gentoo_pkg_postinst
}
