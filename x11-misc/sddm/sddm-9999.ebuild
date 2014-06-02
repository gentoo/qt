# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils git-r3 toolchain-funcs user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
KEYWORDS=""

LICENSE="GPL-2+ MIT CC-BY-3.0 public-domain"
SLOT="0"
IUSE="+qt4 qt5 systemd +upower"
REQUIRED_USE="^^ ( qt4 qt5 )
	?? ( upower systemd )"

RDEPEND="sys-libs/pam
	x11-libs/libxcb[xkb(-)]
	qt4? ( dev-qt/qtdeclarative:4
		   dev-qt/qtdbus:4 )
	qt5? ( dev-qt/qtdeclarative:5
		   dev-qt/qtdbus:5 )
	systemd? ( sys-apps/systemd:= )
	upower? ( sys-power/upower:= )"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.7.0
	virtual/pkgconfig"

src_prepare() {
	# respect user's cflags
	sed -e 's|-Wall -march=native||' \
		-e 's|-O2||' \
		-i CMakeLists.txt || die 'sed failed'
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-version) < 4.7 ]] && \
			die 'The active compiler needs to be gcc 4.7 (or newer)'
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt5 QT5)
	)
	cmake-utils_src_configure
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/sddm ${PN} video
}
