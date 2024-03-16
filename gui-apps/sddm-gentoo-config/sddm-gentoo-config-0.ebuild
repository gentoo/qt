# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo defaults for SDDM (Simple Desktop Display Manager)"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="X"

RDEPEND="
	X? ( x11-base/xorg-server )
	!X? ( dev-libs/weston )
"

src_install() {
	touch "${T}"/01gentoo.conf || die

cat <<-EOF >> "${T}"/01gentoo.conf
[General]
# Which display server should be used
DisplayServer=$(usex X "x11" "wayland")

# Remove qtvirtualkeyboard as InputMethod default
InputMethod=
EOF

	insinto /etc/sddm.conf.d/
	doins "${T}"/01gentoo.conf
}
