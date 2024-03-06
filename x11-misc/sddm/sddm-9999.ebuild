# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

QTMIN=6.6.2
inherit cmake linux-info systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="+elogind +qt5 systemd test +X"

REQUIRED_USE="^^ ( elogind systemd )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	acct-group/sddm
	acct-user/sddm
	sys-libs/pam
	x11-libs/libXau
	x11-libs/libxcb:=
	elogind? ( sys-auth/elogind[pam] )
	qt5? (
		>=dev-qt/qtcore-5.15.12:5
		>=dev-qt/qtdbus-5.15.12:5
		>=dev-qt/qtdeclarative-5.15.12:5
		>=dev-qt/qtgui-5.15.12:5
		>=dev-qt/qtnetwork-5.15.12:5
	)
	!qt5? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network]
		>=dev-qt/qtdeclarative-${QTMIN}:6
	)
	systemd? ( sys-apps/systemd:=[pam] )
	!systemd? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	test? (
		qt5? ( >=dev-qt/qttest-5.15.12:5 )
		!qt5? ( >=dev-qt/qtbase-${QTMIN}:6[network,test] )
	)
"
RDEPEND="${COMMON_DEPEND}
	X? ( x11-base/xorg-server )
	!systemd? ( gui-libs/display-manager-init )
"
BDEPEND="
	dev-python/docutils
	>=dev-build/cmake-3.25.0
	qt5? ( >=dev-qt/linguist-tools-5.15.12:5 )
	!qt5? ( >=dev-qt/qttools-${QTMIN}[linguist] )
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

PATCHES=(
	# Downstream patches
	"${FILESDIR}/${PN}-0.20.0-respect-user-flags.patch"
	"${FILESDIR}/${PN}-0.21.0-Xsession.patch" # bug 611210
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	touch 01gentoo.conf || die

cat <<-EOF >> 01gentoo.conf
[General]
# Remove qtvirtualkeyboard as InputMethod default
InputMethod=
EOF

	cmake_src_prepare

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAN_PAGES=ON
		-DBUILD_WITH_QT6=$(usex !qt5)
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		-DRUNTIME_DIR=/run/sddm
		-DSYSTEMD_TMPFILES_DIR="/usr/lib/tmpfiles.d"
		-DNO_SYSTEMD=$(usex !systemd)
		-DUSE_ELOGIND=$(usex elogind)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc/sddm.conf.d/
	doins "${S}"/01gentoo.conf

	# with systemd logs are sent to journald, so no point to bother in that case
	if ! use systemd; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/sddm.logrotate" sddm
	fi
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "NOTE: If SDDM startup appears to hang then entropy pool is too low."
	elog "This can be fixed by configuring one of the following:"
	elog "  - Enable CONFIG_RANDOM_TRUST_CPU in linux kernel"
	elog "  - # emerge sys-apps/haveged && rc-update add haveged boot"
	elog "  - # emerge sys-apps/rng-tools && rc-update add rngd boot"
	elog
	elog "SDDM example config can be shown with:"
	elog "  ${EROOT}/usr/bin/sddm --example-config"
	elog "Use ${EROOT}/etc/sddm.conf.d/ directory to override specific options."
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
