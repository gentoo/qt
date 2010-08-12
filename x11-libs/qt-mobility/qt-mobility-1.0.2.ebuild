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

# The following APIs are not (yet) supported:
#   - messaging, requires QMF which isn't available
#   - sensors, there are no backends for desktop platforms
QT_MOBILITY_MODULES="bearer contacts +location multimedia +publishsubscribe +serviceframework systeminfo versit"
IUSE="bluetooth debug doc opengl qml +tools ${QT_MOBILITY_MODULES}"

COMMON_DEPEND="
	>=x11-libs/qt-core-4.6.0:4
	bearer? (
		net-misc/networkmanager
		>=x11-libs/qt-dbus-4.6.0:4
		>=x11-libs/qt-gui-4.6.0:4
	)
	multimedia? (
		media-libs/alsa-lib
		>=media-libs/gstreamer-0.10.19:0.10
		>=media-libs/gst-plugins-base-0.10.19:0.10
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
		>=x11-libs/qt-gui-4.6.0:4
		opengl? ( >=x11-libs/qt-opengl-4.6.0:4 )
	)
	publishsubscribe? (
		tools? ( >=x11-libs/qt-gui-4.6.0:4 )
	)
	qml? ( x11-libs/qt-declarative:4 )
	serviceframework? (
		>=x11-libs/qt-sql-4.6.0:4[sqlite]
		tools? ( >=x11-libs/qt-gui-4.6.0:4 )
	)
	systeminfo? (
		net-misc/networkmanager
		x11-libs/libX11
		>=x11-libs/qt-dbus-4.6.0:4
		>=x11-libs/qt-gui-4.6.0:4
		bluetooth? ( net-wireless/bluez )
	)"
DEPEND="${COMMON_DEPEND}
	multimedia? (
		sys-kernel/linux-headers
		x11-proto/videoproto
	)
	systeminfo? ( sys-kernel/linux-headers )
"
RDEPEND="${COMMON_DEPEND}
	systeminfo? ( sys-apps/hal )
"

S=${WORKDIR}/${MY_P}

DOCS="changes-${PV}"
PATCHES=(
	"${FILESDIR}/${P}-fix-tools-linking.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	# translations aren't really translated: disable them
	sed -i -e '/SUBDIRS +=/s:translations::' qtmobility.pro || die

	# fix automagic dependencies on qt-opengl and qt-declarative
	if ! use opengl; then
		sed -i -e '/QT +=/s:opengl::' src/multimedia/multimedia.pro || die
	fi
	if ! use qml; then
		sed -i -e '/SUBDIRS +=/s:declarative::' plugins/plugins.pro || die
	fi
}

src_configure() {
	# the versit module requires contacts support, but luckily
	# config.pri already takes care of enabling it if necessary
	local modules=
	for mod in ${QT_MOBILITY_MODULES//+}; do
		use ${mod} && modules+="${mod} "
	done
	if [[ -z ${modules} ]]; then
		ewarn "At least one module must be selected for building, but you have selected none."
		ewarn "The QtLocation module will be automatically enabled."
		modules="location"
	fi

	# custom configure script
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

	# fix automagic dependency on bluez
	if ! use bluetooth; then
		sed -i -e '/^bluez_enabled =/s:yes:no:' config.pri || die
	fi

	eqmake4 qtmobility.pro -recursive
}

src_install() {
	qt4-r2_src_install

	if use doc; then
		cd "${S}"/doc
		dohtml -r html/* || die
		insinto /usr/share/doc/${PF}
		doins qch/qtmobility.qch || die
	fi
}
