# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build

DESCRIPTION="The Qt3 support module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="+accessibility kde phonon"

DEPEND="~x11-libs/qt-core-${PV}[debug=,qt3support]
	~x11-libs/qt-gui-${PV}[accessibility=,debug=,qt3support]
	~x11-libs/qt-sql-${PV}[debug=,qt3support]
	phonon? (
		!kde? ( || ( ~x11-libs/qt-phonon-${PV}[debug=]
			media-libs/phonon[gstreamer] ) )
		kde? ( media-libs/phonon[gstreamer] ) )"

RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/qt3support
		src/tools/uic3
		tools/designer/src/plugins/widgets
		tools/porting"

	QT4_EXTRACT_DIRECTORIES="src include tools"

	# mac version does not contain qtconfig?
	[[ ${CHOST} == *-darwin* ]] || QT4_TARGET_DIRECTORIES+=" tools/qtconfig"

	qt4-build_pkg_setup
}

src_configure() {
	myconf="${myconf} -qt3support
		$(qt_use phonon gstreamer)
		$(qt_use phonon)
		$(qt_use accessibility)"
	qt4-build_src_configure
}
