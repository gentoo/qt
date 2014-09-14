# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils git-2

DESCRIPTION="Qt-based multitab terminal emulator"
HOMEPAGE="https://github.com/qterminal/"
EGIT_REPO_URI="git://github.com/qterminal/qterminal.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="qt4? ( dev-qt/qtcore:4
               dev-qt/qtgui:4 
               x11-libs/libqxt 
               x11-libs/qtermwidget )
        qt5? ( dev-qt/qtcore:5
                  dev-qt/qtgui:5
                  dev-qt/linguist-tools:5
                  x11-libs/qtermwidget[qt5] )"
RDEPEND="${DEPEND}"

src_configure() {
    mycmakeargs=(
        $(cmake-utils_use_use qt5 QT5)
        $(cmake-utils_use_use qt4 SYSTEM_QXT)
    )
    cmake-utils_src_configure
}
