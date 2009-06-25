# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.5.1.ebuild,v 1.11 2009/06/06 08:43:39 maekke Exp $

EAPI=2
DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
HOMEPAGE="http://www.qtsoftware.com/"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="4"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ~ppc64 -sparc x86"
IUSE="+dbus kde opengl +qt3support"

DEPEND=""
RDEPEND="~x11-libs/qt-core-${PV}
	~x11-libs/qt-gui-${PV}
	~x11-libs/qt-svg-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-xmlpatterns-${PV}
	dbus? ( ~x11-libs/qt-dbus-${PV} )
	opengl? ( ~x11-libs/qt-opengl-${PV} )
	!kde? ( || ( ~x11-libs/qt-phonon-${PV} media-sound/phonon ) )
	kde? ( media-sound/phonon )
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
