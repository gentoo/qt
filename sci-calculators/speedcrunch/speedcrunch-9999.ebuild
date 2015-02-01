# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="A fast and usable calculator for power users"
HOMEPAGE="http://speedcrunch.org/"
EGIT_REPO_URI="git://gitorious.org/${PN}/mainline"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

LANGS="ar_JO ca_ES cs_CZ de_DE en_US es_ES eu_ES fi_FI fr_FR he_IL id_ID it_IT
	nb_NO nl_NL pl_PL pt_PT ro_RO ru_RU sv_SE tr_TR zh_CN"
LANGSLONG="en_GB es_AR pt_BR"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X%_*}"
done
for X in ${LANGSLONG}; do
	IUSE="${IUSE} linguas_${X}"
done

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	for X in ${LANGS}; do
		use linguas_${X%_*} && lrelease "src/locale/${X}.ts"
	done
	for X in ${LANGSLONG}; do
		use linguas_${X} && lrelease "src/locale/${X}.ts"
	done

	S="${S}/src"
}

src_install() {
	cmake-utils_src_install

	# prevent install of empty dir
	rmdir "${D}/usr/share/${PN}/locale" 2>/dev/null

	cd ..
	dodoc ChangeLog HACKING README
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf
	fi
}
