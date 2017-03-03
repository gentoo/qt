# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/scarpin0/${PN}.git"
	inherit git-r3
	KEYWORDS=""
	SYSTEMD_VERSION=">=sys-apps/systemd-207"
else
	SRC_URI="https://github.com/scarpin0/libsystemd-qt/archive/${PV}.zip -> ${P}.zip"
	KEYWORDS="~amd64"
	SYSTEMD_VERSION="~sys-apps/systemd-${PV}"
fi

DESCRIPTION="Qt wrapper for systemd API"
HOMEPAGE="https://github.com/scarpin0/libsystemd-qt"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug qml qt4 +qt5 test"

RDEPEND="
	${SYSTEMD_VERSION}
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		qml? ( dev-qt/qtdeclarative:5 )
	)
"
DEPEND="${RDEPEND}
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"
REQUIRED_USE="
	^^ ( qt4 qt5 )
	qml? ( qt5 )
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT4=$(usex qt4)
		-DBUILD_QTSYSTEMD_TESTS=$(usex test)
		-DBUILD_QTSYSTEMD_QMLPLUGIN=$(usex qml)
	)

	cmake-utils_src_configure
}
