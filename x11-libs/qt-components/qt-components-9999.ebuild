# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git
	https://git.gitorious.org/${PN}/${PN}.git"

inherit qt4-r2 git-2

DESCRIPTION="QtQuick/QML components and models"
HOMEPAGE="http://qt.gitorious.org/qt-components/qt-components"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""

IUSE="extras meego mobility symbian test"

DEPEND="
	>=x11-libs/qt-core-4.7.4:4
	>=x11-libs/qt-declarative-4.7.4:4
	meego? (
		x11-libs/libXdamage
		x11-libs/libXrandr
		>=x11-libs/qt-dbus-4.7.4:4
		>=x11-libs/qt-opengl-4.7.4:4
		mobility? ( >=x11-libs/qt-mobility-1.2[systeminfo] )
	)
	symbian? (
		>=x11-libs/qt-svg-4.7.4:4
		mobility? ( >=x11-libs/qt-mobility-1.2[feedback,systeminfo] )
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local myconf=(
		./configure
		-prefix "${EPREFIX}/usr"
		-nomake demos
		-nomake examples
		$(use extras && echo -make || echo -nomake) extras
		$(use test && echo -make || echo -nomake) tests
		$(use meego && echo -meego)
		$(use symbian && echo -symbian)
		-no-meegotouch
		-no-maliit
		-no-contextsubscriber
		-no-meegographicssystem
		-xdamage
		$(use mobility || echo -no)-mobility
	)
	echo "${myconf[@]}"
	"${myconf[@]}" || die "configure failed"
}
