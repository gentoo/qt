# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-qt3support/qt-qt3support-4.7.4.ebuild,v 1.1 2011/09/08 09:21:19 wired Exp $

EAPI="4"
if [[ ${PV} == 4*9999 ]]; then
    QT_ECLASS="-edge"
fi
inherit qt4-build${QT_ECLASS}

DESCRIPTION="The Qt3 support module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
else
	KEYWORDS=""
fi

IUSE="+accessibility"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support]
	~x11-libs/qt-gui-${PV}[accessibility=,aqua=,c++0x=,qpa=,debug=,qt3support]
	~x11-libs/qt-sql-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support]"

RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/qt3support
		src/tools/uic3
		tools/designer/src/plugins/widgets
		tools/porting"
	if [[ ${PV} != 4*9999 ]]; then
		QT4_EXTRACT_DIRECTORIES="src include tools"
	fi

	qt4-build${QT_ECLASS}_pkg_setup
}

src_configure() {
	myconf="${myconf} -qt3support
		$(qt_use accessibility)"
	qt4-build${QT_ECLASS}_src_configure
}
