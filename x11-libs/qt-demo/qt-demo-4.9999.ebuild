# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="Demonstration module of the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
else
	KEYWORDS=""
fi
IUSE="kde qt3support"

DEPEND="~x11-libs/qt-assistant-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-core-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-dbus-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-declarative-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=,webkit]
	~x11-libs/qt-gui-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-multimedia-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-opengl-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	!kde? ( || ( ~x11-libs/qt-phonon-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
		media-libs/phonon[aqua=,debug=] ) )
	kde? ( media-libs/phonon[aqua=,debug=] )
	~x11-libs/qt-script-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-sql-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-svg-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-test-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-webkit-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-xmlpatterns-${PV}:${SLOT}[aqua=,c++0x=,qpa=,debug=]"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.6-plugandpaint.patch" )

pkg_setup() {
	QT4_TARGET_DIRECTORIES="demos
		examples"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		doc/src/images
		src/
		include/
		tools/"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} $(qt_use qt3support) -no-openvg"
	qt4-build-edge_src_configure
}

src_install() {
	insinto "${QTDOCDIR#${EPREFIX}}"/src
	doins -r "${S}"/doc/src/images || die "Installing images failed."

	qt4-build-edge_src_install
}
