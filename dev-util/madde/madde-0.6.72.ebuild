# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Maemo Application Development and Debugging Environment"
HOMEPAGE="http://wiki.maemo.org/MADDE"
SRC_URI="amd64? (
			http://tablets-dev.nokia.com/install-madde-0.6.72-linux-x86_64.sh )
		x86? (
			http://tablets-dev.nokia.com/install-madde-0.6.72-linux-i686.sh	)"

LICENSE="Nokia-SDK"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
# Restrict fetching & mirror because of the License"
# Restrict strip because of the precompiled binaries
RESTRICT="fetch mirror strip"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"
# Qt4 version supported by this release
QTVER="4.6.2"

mypkg() {
	MY_PT="install-${P}-linux"
	use amd64 && MY_P="${MY_PT}-x86_64.sh"
	use x86 && MY_P="${MY_PT}-i686.sh"
}

pkg_setup() {
	mypkg
}

pkg_nofetch() {
	mypkg
	eerror "You need to manually download the madde "
	eerror "installer from"
	eerror "http://tablets-dev.nokia.com/MADDE.php"
	eerror
	eerror "For an ${ARCH} host download the following file:"
	eerror "${MY_P} and put it on"
	eerror "${DISTDIR}"
}

src_unpack() {
	# copy the installer to the working directory
	cp "${DISTDIR}"/${MY_P} "${WORKDIR}"/${MY_P}
}

src_prepare() {
	# disable any user interaction
	epatch "${FILESDIR}"/${P}-no-interactive.patch
	# fix the installation path
	sed -i "s:/opt/:"${D}"opt/${PN}:" ${MY_P}
	# disable xtar extraction. Will do it later
	sed -i "/^perl -x/d" ${MY_P}
	# remove the postinstall scripts. We will do it later
	sed -i "/postinstall\/postinstall.sh/d" ${MY_P}
}

src_install() {
	dodir "/opt/${PN}/${PV}/"
	chmod 755 "${S}"/${MY_P}
	# extract the xtar binary
	perl -x "${MY_P}" xtar > "${D}opt/${PN}/${PV}/xtar"
	# run the installer
	# patch postinstaller
	sh "${S}"/${MY_P}
	# run the postinst process again to fix the paths
	sed -i "s:^mypath.*:mypath=\"/opt/${PN}/${PV}/\":" \
		"${D}"opt/${PN}/${PV}/postinstall/postinstall.sh

}

pkg_postinst() {
	sh /opt/${PN}/${PV}/postinstall/postinstall.sh
	elog ">=dev-util/qt-creator-2.0.0 can use madde to create"
	elog "an extremely useful Maemo development enviroment."
	elog "To integrate madde to qt-creator go to"
	elog "Tools -> Options -> Qt4 -> Add"
	elog "Version Name: ${QTVER}"
	elog "qmake location: /opt/${PN}/${PV}/targets/fremantle-pr12/bin/qmake"
	elog "Apply the changes"
	elog
	elog "Wiki: ${HOMEPAGE}"
}
