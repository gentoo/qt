# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qscintilla-python/qscintilla-python-2.4.3.ebuild,v 1.1 2010/03/18 01:12:23 yngwin Exp $

EAPI="2"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python toolchain-funcs

HG_REVISION="8bac389fb7ae"
MY_P="QScintilla-gpl-snapshot-${PV/_pre*/-${HG_REVISION}}"

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://gentoo-el.org/~hwoarang/distfiles/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND=">=dev-python/sip-4.10
	>=dev-python/PyQt4-4.7[X]
	~x11-libs/qscintilla-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/Python"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4-nostrip.patch

	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf="$(PYTHON) configure.py -p 4
				--destdir=$(python_get_sitedir)/PyQt4
				$(use debug && echo '--debug')"
		echo ${myconf}
		${myconf}
	}
	python_execute_function -s configuration
}

src_compile() {
	building() {
		emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINK="$(tc-getCXX)"
	}
	python_execute_function -s building
}
