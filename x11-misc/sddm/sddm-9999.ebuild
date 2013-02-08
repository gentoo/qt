# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils git-2

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
EGIT_REPO_URI="git://github.com/sddm/sddm.git"

LICENSE="GPL-2+ MIT CC-BY-3.0 public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-libs/pam
	x11-libs/qt-declarative:4"
RDEPEND="${DEPEND}"

src_prepare() {
	# respect our cflags, and make it work with gcc-4.6 (hopefully)
	sed -e 's|-Wall -march=native -O2 -g -std=c++11|-std=c++0x|' \
		-i CMakeLists.txt || die 'sed failed'
}
