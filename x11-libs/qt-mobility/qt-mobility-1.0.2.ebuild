# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit multilib qt4-r2

MY_P="${PN}-opensource-src-${PV}"

DESCRIPTION="Qt APIs for mobile devices"
HOMEPAGE="http://labs.trolltech.com/page/Projects/QtMobility"
SRC_URI="http://get.qt.nokia.com/qt/solutions/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bearer contacts debug doc multimedia opengl +publishsubscribe +serviceframework +systeminfo +tools versit"
# The following APIs are not (yet) supported:
#   - messaging, requires QMF which isn't available
#   - sensors, there are no backends for desktop platforms

DEPEND=">=x11-libs/qt-core-4.6.0:4
	bearer? (
		net-misc/networkmanager
		>=x11-libs/qt-dbus-4.6.0:4
		>=x11-libs/qt-gui-4.6.0:4
	)
	multimedia? (
		media-libs/alsa-lib
		>=media-libs/gstreamer-0.10.19:0.10
		>=media-libs/gst-plugins-base-0.10.19:0.10
		x11-libs/libXv
		>=x11-libs/qt-gui-4.6.0:4
		opengl? ( >=x11-libs/qt-opengl-4.6.0:4 )
	)
	publishsubscribe? (
		tools? ( >=x11-libs/qt-gui-4.6.0:4 )
	)
	serviceframework? (
		>=x11-libs/qt-sql-4.6.0:4[sqlite]
		tools? ( >=x11-libs/qt-gui-4.6.0:4 )
	)
	systeminfo? (
		net-misc/networkmanager
		net-wireless/bluez
		sys-kernel/linux-headers
		>=x11-libs/qt-dbus-4.6.0:4
		>=x11-libs/qt-gui-4.6.0:4
	)"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="changes-${PV}"
PATCHES=(
	"${FILESDIR}/${P}-fix-tools-linking.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	# translations aren't really translated: disable them
	sed -i -e '/SUBDIRS +=/s/translations//' qtmobility.pro || die

	# fix automagic dependency on qt-opengl
	if ! use opengl; then
		sed -i -e '/QT +=/s/opengl//' src/multimedia/multimedia.pro || die
	fi
}

src_configure() {
	local modules="location"
	for mod in bearer contacts multimedia publishsubscribe \
			serviceframework systeminfo versit; do
		use ${mod} && modules+=" ${mod}"
	done

	local myconf="./configure
			-prefix '${EPREFIX}/usr'
			-headerdir '${EPREFIX}/usr/include/qt4'
			-libdir '${EPREFIX}/usr/$(get_libdir)/qt4'
			-plugindir '${EPREFIX}/usr/$(get_libdir)/qt4/plugins'
			$(use debug && echo -debug || echo -release)
			$(use tools || echo -no-tools)
			-modules '${modules}'
			-no-docs"
	echo ${myconf}
	eval ${myconf} || die "./configure failed"

	eqmake4 qtmobility.pro -recursive
}

src_install() {
	qt4-r2_src_install

	if use doc; then
		einfo "Installing API documentation"
		cd "${S}"/doc
		dohtml -r html/* || die
		insinto /usr/share/doc/${PF}
		doins qch/qtmobility.qch || die
	fi
}
