# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEFINE_DEFAULT_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit eutils multilib python toolchain-funcs

MY_P="QScintilla-gpl-${PV/_pre/-snapshot-}"

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug"

DEPEND=">=dev-python/sip-4.8
	>=dev-python/PyQt4-4.5[X]
	~x11-libs/qscintilla-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/Python"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4-nostrip.patch"

	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf="$(PYTHON) configure.py
				--destdir=$(python_get_sitedir)/PyQt4
				-n /usr/include
				-o /usr/$(get_libdir)
				-p 4
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
