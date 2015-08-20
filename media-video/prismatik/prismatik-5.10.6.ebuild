# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils udev

MY_PN=${PN/prismatik/Lightpack}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Prismatik is an open-source software to control Lightpack devices"
HOMEPAGE="http://lightpack.tv"
SRC_URI="https://github.com/Atarity/Lightpack/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5
	media-libs/mesa
	virtual/libusb:1
	virtual/udev
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}/Software"

src_prepare() {
	rm -rf qtserialport
	sed -e "/qtserialport/d" -i ${MY_PN}.pro || die
}

src_configure() {
	eqmake5 ${MY_PN}.pro
}

src_install() {
	newbin src/bin/Prismatik ${PN}

	domenu dist_linux/deb/usr/share/applications/${PN}.desktop

	insinto /usr/share/
	doins -r dist_linux/deb/usr/share/{icons,pixmaps}

	udev_dorules dist_linux/deb/etc/udev/rules.d/93-lightpack.rules
}
