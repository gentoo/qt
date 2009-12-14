# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="${P/_/-}"

inherit base

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
SRC_URI="http://toxygen.net/libgadu/files/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="doc ssl static-libs threads"

COMMON_DEPEND="
	ssl? ( >=dev-libs/openssl-0.9.6m )
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	!=net-im/kadu-0.6.0.2
	!=net-im/kadu-0.6.0.1
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
	    --enable-shared \
		$(use_enable static-libs static) \
	    $(use_with threads pthread) \
	    $(use_with ssl openssl)
}

src_install() {
	base_src_install

	if ! use static-libs; then
		find "${D}" -type f -name '*.la' -exec rm -rf '{}' '+' \
			|| die "la removal failed"
	fi

	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"

	if use doc; then
		dohtml -r docs/html/* || die "dohtml failed"
	fi
}
