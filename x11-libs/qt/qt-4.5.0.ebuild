# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.5.0_rc1.ebuild,v 1.1 2009/02/14 00:37:14 yngwin Exp $

EAPI=2
DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
HOMEPAGE="http://www.qtsoftware.com/"

LICENSE="|| ( LGPL-2.1 GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="+dbus opengl +qt3support"

DEPEND=""
RDEPEND="~x11-libs/qt-core-${PV}
	~x11-libs/qt-gui-${PV}
	~x11-libs/qt-svg-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-xmlpatterns-${PV}
	dbus? ( ~x11-libs/qt-dbus-${PV} )
	opengl? ( ~x11-libs/qt-opengl-${PV} )
	|| ( ~x11-libs/qt-phonon-${PV} media-sound/phonon )
	qt3support? ( ~x11-libs/qt-qt3support-${PV} )
	~x11-libs/qt-webkit-${PV}
	~x11-libs/qt-test-${PV}
	~x11-libs/qt-assistant-${PV}"

pkg_postinst() {
	echo
	elog "Please note that this meta package is only provided for convenience."
	elog "No packages should depend directly on this meta package, but on the"
	elog "specific split Qt packages needed. This ebuild will be removed in"
	elog "future versions. Users that want all Qt components installed are"
	elog "advised to use the set currently available in qting-edge overlay."
	echo
}
