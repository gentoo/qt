# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eric/eric-4.3.4.ebuild,v 1.1 2009/06/05 20:58:42 yngwin Exp $

EAPI="2"
NEED_PYTHON=2.4

inherit python eutils

MY_PN="${PN}4"
MY_PV="${PV/_pre/-snapshot-}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A full featured Python IDE that is written in PyQt4 using the QScintilla editor widget"
HOMEPAGE="http://eric-ide.python-projects.org/index.html"
SRC_URI="mirror://sourceforge/eric-ide/${MY_P}.tar.gz
	linguas_cs? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-cs-${MY_PV}.tar.gz )
	linguas_de? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-de-${MY_PV}.tar.gz )
	linguas_es? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-es-${MY_PV}.tar.gz )
	linguas_fr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-fr-${MY_PV}.tar.gz )
	linguas_ru? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-ru-${MY_PV}.tar.gz )
	linguas_tr? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-tr-${MY_PV}.tar.gz )
	linguas_zh_CN? ( mirror://sourceforge/eric-ide/${MY_PN}-i18n-zh_CN.GB2312-${MY_PV}.tar.gz )"
RESTRICT="mirror"

SLOT="4"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="linguas_cs linguas_de linguas_es linguas_fr linguas_ru linguas_tr spell"

DEPEND="dev-python/PyQt4[X,assistant,svg,webkit]
	>=dev-python/qscintilla-python-2.2[qt4]"
RDEPEND="${DEPEND}"
PDEPEND="spell? ( dev-python/pyenchant )"

S="${WORKDIR}"/${MY_P}

LANGS="cs de es fr ru tr"

src_prepare() {
	epatch "${FILESDIR}"/eric-snapshot-20090627-no-interactive.patch
}

src_install() {
	python_version

	# Change qt dir to be located in ${D}
	dodir /usr/share/qt4
	${python} install.py \
		-z \
		-b "/usr/bin" \
		-d "$(python_get_sitedir)" \
		-i "${D}" \
		-c || die "installation failed"

	make_desktop_entry "eric4" \
			eric4 \
			"$(python_get_sitedir)/eric4/icons/default/eric.png" \
			"Development;IDE;Qt"
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)"/eric4{,plugins}

	elog "If you want to use eric4 with mod_python, have a look at"
	elog "'${ROOT%/}$(python_get_sitedir)/eric4/patch_modpython.py'."
	elog
	elog "The following packages will give eric extended functionality:"
	elog
	elog "dev-python/pylint"
	elog "dev-python/pysvn            (in sunrise overlay atm)"
	elog
	elog "This version has a plugin interface with plugin-autofetch from"
	elog "the application itself. You may want to check those as well."
}

pkg_postrm() {
	python_mod_cleanup
}
