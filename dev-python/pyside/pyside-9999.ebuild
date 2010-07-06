# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug kde"

QT_PV="4.6.0"

DEPEND=">=dev-libs/boost-1.41.0[python]
	~dev-python/shiboken-${PV}
	>=x11-libs/qt-core-${QT_PV}
	>=x11-libs/qt-assistant-${QT_PV}
	>=x11-libs/qt-gui-${QT_PV}
	>=x11-libs/qt-opengl-${QT_PV}
	kde? ( media-sound/phonon )
	!kde? ( || ( >=x11-libs/qt-phonon-${QT_PV}
		media-sound/phonon ) )
	>=x11-libs/qt-script-${QT_PV}
	>=x11-libs/qt-sql-${QT_PV}
	>=x11-libs/qt-svg-${QT_PV}
	>=x11-libs/qt-webkit-${QT_PV}
	>=x11-libs/qt-xmlpatterns-${QT_PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
