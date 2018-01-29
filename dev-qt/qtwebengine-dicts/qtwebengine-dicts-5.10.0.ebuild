# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils versionator

DESCRIPTION="Hunspell dictionaries for QtWebEngine"
HOMEPAGE="https://doc.qt.io/qt-5/qtwebengine-webenginewidgets-spellchecker-example.html"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

# Cribbed from app-text/hunspell
LANGS="af bg ca cs cy da de de-1901 el en eo es et fo fr ga gl he hr hu ia id
is it kk km ku lt lv mi mk ms nb nl nn pl pt pt-BR ro ru sk sl sq sv sw tn uk
zu"

DEPEND="
	app-dicts/myspell-en
	dev-qt/qtwebengine:$(get_major_version)"

for lang in ${LANGS}; do
	IUSE+=" l10n_${lang}"
	case ${lang} in
		de-1901) dict="de_1901";;
		pt-BR)   dict="pt-br";;
		*)       dict="${lang}";;
	esac
	DEPEND+=" l10n_${lang}? ( app-dicts/myspell-${dict} )"
done
unset dict lang

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_configure() {
	:
}

src_compile() {
	local dicts
	local dic
	local bdic_fn
	local prefix

	mkdir -p "${T}"/bdics || die

	# File-renaming done to match
	# https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries.git/+/master

	# TODO:  This doesn't respect the l10n USE flags for the package and rather
	# just builds qtwebengine dictionaries for everything that is installed.
	# It's not immediately obvious how to filter as there isn't a consistent
	# map from language to dictionaries.  For example:
	# 	en: en_AU, en_CA, en_GB, en_US, en_ZA
	# 	kk: kk_KZ, kk_noun_adj, kk_test
	# 	pt-BR: pt_BR
	# etc.
	for dic in "${EPREFIX}"/usr/share/hunspell/*.dic; do
		bdic_fn=$(basename ${dic})
		bdic_fn=${bdic_fn%.dic}
		bdic_fn=${bdic_fn/_/-}-$(get_major_version)-$(get_version_component_range 2).bdic

		$(qt5_get_bindir)/qwebengine_convert_dict \
			${dic} \
			"${T}"/bdics/${bdic_fn} || die
	done
}

src_install() {
	insinto /usr/share/qt5/qtwebengine_dictionaries
	doins "${T}"/bdics/*.bdic
}
