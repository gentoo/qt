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
IUSE="+bearer contacts debug doc -multimedia opengl +publishsubscribe +serviceframework +systeminfo +tools versit"
# messaging and sensors APIs are not (yet) supported

DEPEND=">=x11-libs/qt-core-4.6.0:4
	bearer? (
		net-misc/networkmanager
		>=x11-libs/qt-dbus-4.6.0:4
		>=x11-libs/qt-gui-4.6.0:4
	)
	multimedia? (
		>=x11-libs/qt-multimedia-4.6.0:4
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
		>=x11-libs/qt-dbus-4.6.0:4
		>=x11-libs/qt-gui-4.6.0:4
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-fix-quoting.patch"
	"${FILESDIR}/${P}-fix-tools-linking.patch"
)

src_configure() {
	if ! use opengl; then
		sed -i -e '/: QT += opengl$/d' src/multimedia/multimedia.pro || die
	fi

	local modules="location"
	for mod in bearer contacts multimedia publishsubscribe \
			serviceframework systeminfo versit; do
		use ${mod} && modules+=" ${mod}"
	done
	local myconf="./configure
			-prefix '${EPREFIX}/usr'
			-headerdir '${EPREFIX}/usr/include/qt4'
			-libdir '${EPREFIX}/usr/$(get_libdir)/qt4'
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
