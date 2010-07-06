# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="A full featured Python IDE using PyQt4 and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"

SLOT="4"
MY_PN="${PN}${SLOT}"
MY_PV="${PV/_pre/-snapshot-}"
MY_P="${MY_PN}-${MY_PV}"

BASE_URI="mirror://sourceforge/eric-ide/${MY_PN}/unstable/${PV##*_pre}"
SRC_URI="${BASE_URI}/${MY_P}.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="kde spell"

DEPEND="dev-python/PyQt4[assistant,svg,webkit,X]
	dev-python/qscintilla-python
	kde? ( kde-base/pykde4 )"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.0.1
	>=dev-python/coverage-3.0.1
	>=dev-python/pygments-1.1"
PDEPEND="spell? ( dev-python/pyenchant )"
# 2.4 and 2.5 are restricted to avoid conditional dependency on dev-python/simplejson.
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"

LANGS="cs de es fr it ru tr zh_CN"
for L in ${LANGS}; do
	SRC_URI="${SRC_URI}
		linguas_${L}? ( ${BASE_URI}/${MY_PN}-i18n-${L/zh_CN/zh_CN.GB2312}-${MY_PV}.tar.gz )"
	IUSE="${IUSE} linguas_${L}"
done
unset L

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.4-no-interactive.patch"
	epatch "${FILESDIR}/${PN}-4.5_remove_coverage.patch"
	use kde || epatch "${FILESDIR}/${PN}-4.4-no-pykde.patch"

	# Delete internal copies of dev-python/chardet, dev-python/coverage,
	# dev-python/pygments and dev-python/simplejson
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
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN} "Development;IDE;Qt"
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
