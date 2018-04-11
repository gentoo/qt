# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/scarpin0/${PN}.git"
	inherit git-r3
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
IUSE="debug test"

RDEPEND="
	${SYSTEMD_VERSION}
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT4=OFF
		-DBUILD_QTSYSTEMD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}
