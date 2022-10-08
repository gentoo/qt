# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

inherit cmake linux-info systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="+elogind +pam systemd test"

REQUIRED_USE="?? ( elogind systemd )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	acct-group/sddm
	acct-user/sddm
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	x11-base/xorg-server
	x11-libs/libxcb
	elogind? ( sys-auth/elogind )
	pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	!systemd? ( gui-libs/display-manager-init )
"
BDEPEND="
	dev-python/docutils
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig
"

PATCHES=(
	# Downstream patches
	"${FILESDIR}/${PN}-0.18.1-respect-user-flags.patch" # bug 563108
	"${FILESDIR}/${PN}-0.19.0-Xsession.patch" # bug 611210
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PAM=$(usex pam)
		-DNO_SYSTEMD=$(usex '!systemd')
		-DUSE_ELOGIND=$(usex 'elogind')
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"

	# Create a default.conf as upstream dropped /etc/sddm.conf w/o replacement
	local confd="/usr/lib/sddm/sddm.conf.d"
	dodir ${confd}
	"${D}"/usr/bin/sddm --example-config > "${D}/${confd}"/00default.conf \
		|| die "Failed to create 00default.conf"

	sed -e "/^InputMethod/s/qtvirtualkeyboard//" \
		-e "/^ReuseSession/s/false/true/" \
		-e "/^EnableHiDPI/s/false/true/" \
		-i "${D}/${confd}"/00default.conf || die
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "Starting with 0.18.0, SDDM no longer installs /etc/sddm.conf"
	elog "Use it to override specific options. SDDM defaults are now"
	elog "found in: /usr/lib/sddm/sddm.conf.d/00default.conf"
	elog
	elog "NOTE: If SDDM startup appears to hang then entropy pool is too low."
	elog "This can be fixed by configuring one of the following:"
	elog "  - Enable CONFIG_RANDOM_TRUST_CPU in linux kernel"
	elog "  - # emerge sys-apps/haveged && rc-update add haveged boot"
	elog "  - # emerge sys-apps/rng-tools && rc-update add rngd boot"
	elog
	elog "For more information on how to configure SDDM, please visit the wiki:"
	elog "  https://wiki.gentoo.org/wiki/SDDM"
	if has_version x11-drivers/nvidia-drivers; then
		elog
		elog "  Nvidia GPU owners in particular should pay attention"
		elog "  to the troubleshooting section."
	fi

	systemd_reenable sddm.service
}
