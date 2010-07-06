# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="3"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="A full featured Python IDE using PyQt4 and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"

SLOT="5"
MY_PN="${PN}${SLOT}"
MY_PV="${PV/_pre/-snapshot-}"
MY_P="${MY_PN}-${MY_PV}"

BASE_URI="mirror://sourceforge/eric-ide/${MY_PN}/stable/${PV}"
SRC_URI="${BASE_URI}/${MY_P}.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="spell"

DEPEND=">=dev-python/PyQt4-4.7[assistant,svg,webkit,X]
	>=dev-python/qscintilla-python-2.4"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.0.1
	>=dev-python/coverage-3.2
	>=dev-python/pygments-1.1.1"
PDEPEND="spell? ( dev-python/pyenchant )"
RESTRICT_PYTHON_ABIS="2.*"

LANGS="cs de es it ru"
for L in ${LANGS}; do
	SRC_URI="${SRC_URI}
		linguas_${L}? ( ${BASE_URI}/${MY_PN}-i18n-${L/zh_CN/zh_CN.GB2312}-${MY_PV}.tar.gz )"
	IUSE="${IUSE} linguas_${L}"
done
unset L

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.0_no_interactive.patch"
	epatch "${FILESDIR}/${PN}-5.0_remove_coverage.patch"
	epatch "${FILESDIR}/${PN}-5.0_sandbox.patch"

	# Avoid file collisions among different SLOTs of eric
	sed -i -e "s/^Icon=eric$/&${SLOT}/" eric/${MY_PN}.desktop || die
	rm -f eric/APIs/Python/zope-*.api
	rm -f eric/APIs/Ruby/Ruby-*.api

	# Delete internal copies of dev-python/chardet,
	# dev-python/coverage and dev-python/pygments
	rm -fr eric/ThirdParty
	rm -fr eric/DebugClients/Python{,3}/coverage
}

src_install() {
	installation() {
		"$(PYTHON)" install.py \
			-z \
			-b "${EPREFIX}/usr/bin" \
			-i "${D}" \
			-d "${EPREFIX}$(python_get_sitedir)" \
			-c
	}
	python_execute_function installation

	newicon eric/icons/default/eric.png ${MY_PN}.png || die
	domenu eric/${MY_PN}.desktop || die
}

pkg_postinst() {
	python_mod_optimize ${MY_PN}{,config.py,plugins}

	elog
	elog "If you want to use Eric with mod_python, have a look at"
	elog "\"${EROOT%/}$(python_get_sitedir -f)/${MY_PN}/patch_modpython.py\"."
	elog
	elog "The following packages will give Eric extended functionality:"
	elog "  dev-python/pylint"
	elog "  dev-python/pysvn"
	elog
	elog "This version has a plugin interface with plugin-autofetch from"
	elog "the application itself. You may want to check those as well."
	elog
}

pkg_postrm() {
	python_mod_cleanup ${MY_PN}{,config.py,plugins}
}
