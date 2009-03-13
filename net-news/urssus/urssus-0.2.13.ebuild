# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

MY_P="uRSSus-${PV}"

DESCRIPTION="A Qt-based RSS/Atom news aggregator"
HOMEPAGE="http://www.qt-apps.org/content/show.php/uRSSus?content=99928"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/PyQt4
	dev-python/elixir
	dev-python/paver"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	true
}

# overriding default src_install as it fails due to paver related issues
src_install() {
	paver install || die "paver installed failed"
	dodoc README || die "dodoc failed"
}
