# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KDE_REQUIRED="optional"
inherit cmake-utils kde4-base multilib

KDE_AUTODEPS=false
KDE_DEBUG=false
KDE_HANDBOOK=false # needed for kde5.eclass, but misinterpreted by kde4-base.eclass
inherit kde5

DESCRIPTION="A set of widget styles for Qt and GTK2"
HOMEPAGE="https://projects.kde.org/projects/playground/base/qtcurve"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://anongit.kde.org/qtcurve.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/QtCurve/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/QtCurve/${PN}/commit/69047935dd4a9549d238cbc457e9c3cfa37386ae.patch -> ${P}-old_config_file.patch"
	KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+X gtk kde kf5 nls +qt4 qt5 windeco"
REQUIRED_USE="gtk? ( X )
	kde? ( qt4 X )
	kf5? ( qt5 )
	windeco? ( kde )
	|| ( gtk qt4 qt5 )"

RDEPEND="X? ( x11-libs/libxcb
		x11-libs/libX11
		x11-libs/xcb-util-image )
	gtk? ( x11-libs/gtk+:2 )
	qt4? ( dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4 )
	qt5? ( dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtdbus:5
			dev-qt/qtx11extras:5 ) )
	kde? ( $(add_kdebase_dep systemsettings)
		windeco? ( $(add_kdebase_dep kwin) ) )
	kf5? ( $(add_frameworks_dep extra-cmake-modules)
		$(add_frameworks_dep karchive)
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep ki18n)
		$(add_frameworks_dep kdelibs4support)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep kxmlgui) )
	!x11-themes/gtk-engines-qtcurve"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

[[ ${PV} == *9999* ]] || PATCHES=( "${DISTDIR}/${P}-old_config_file.patch" )

pkg_setup() {
	use kde && kde4-base_pkg_setup
}

src_configure() {
	local mycmakeargs
	mycmakeargs=(
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		$(cmake-utils_use_enable gtk GTK2)
		$(cmake-utils_use_enable qt4 QT4)
		$(cmake-utils_use_enable qt5 QT5)
		$(cmake-utils_use X QTC_ENABLE_X11 )
		$(cmake-utils_use kde QTC_QT4_ENABLE_KDE )
		$(cmake-utils_use windeco QTC_QT4_ENABLE_KWIN )
		$(cmake-utils_use kf5 QTC_QT5_ENABLE_KDE )
		$(cmake-utils_use nls QTC_INSTALL_PO )
	)
	cmake-utils_src_configure
}
