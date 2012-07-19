# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: l10n.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>
# @BLURB: convenience functions to handle localizations
# @DESCRIPTION:
# The l10n (localization) eclass offers a number of functions to more
# conveniently handle localizations (translations) offered by packages.
# These are meant to prevent code duplication for such boring tasks as
# determining the cross-section between the user's set LINGUAS and what
# is offered by the package; and generating the right list of linguas_*
# USE flags.

# @ECLASS-VARIABLE: PLOCALES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Variable listing the locales for which localizations are offered by
# the package. Check profiles/desc/linguas.desc to see if the locales
# are listed there. Add any missing ones there.
#
# Example: PLOCALES="cy de el_GR en_US pt_BR vi zh_CN"

# @ECLASS-VARIABLE: PLOCALE_BACKUP
# @DEFAULT_UNSET
# @DESCRIPTION:
# In some cases the package fails when none of the offered PLOCALES are
# selected by the user. In that case this variable should be set to a
# default locale (usually 'en' or 'en_US') as backup.
#
# Example: PLOCALE_BACKUP="en_US"

# Add linguas useflags
[[ -n "${PLOCALES}" ]] && IUSE+=" $(printf 'linguas_%s ' ${PLOCALES})"

# @FUNCTION: l10n_for_each_locale_do
# @USAGE: <function>
# @DESCRIPTION:
# Convenience function for processing localizations. The parameter should
# be a function (defined in the consuming eclass or ebuild) which takes
# an individual localization as (last) parameter.
#
# Example: l10n_for_each_locale_do install_locale
l10n_for_each_locale_do() {
	local xlocs=
	xlocs=$(l10n_get_linguas_crosssection)
	if [[ -n "${xlocs}" ]]; then
		local x
		for x in ${xlocs}; do
			${@} ${x} || die "failed to process ${x} locale"
		done
	fi
}

# @FUNCTION: l10n_for_each_unselected_locale_do
# @USAGE: <function>
# @DESCRIPTION:
# Complementary to l10n_for_each_locale_do, this function will process
# locales that are not selected. This could be used for example to remove
# locales from a Makefile, to prevent them from being built needlessly.
l10n_for_each_unselected_locale_do() {
	local o= x=
	o=$(join -v 1 <(echo "${PLOCALES// /$'\n'}") <(echo "${LINGUAS// /$'\n'}") )
	o=${o//$'\n'/' '}
	einfo "Unselected locales are: ${o}"
	if [[ -n "${o}" ]]; then
		for x in ${o}; do
			${@} ${x} || die "failed to process unselected ${x} locale"
		done
	fi
}

# @FUNCTION: l10n_find_plocales_changes
# @USAGE: <translations dir> <filename pre pattern> <filename post pattern>
# @DESCRIPTION:
# Ebuild maintenance helper function to find changes in package offered
# locales when doing a version bump. This could be added for example to
# src_prepare
#
# Example: l10n_find_plocales_changes "${S}/src/translations" "${PN}_" '.ts'
l10n_find_plocales_changes() {
	[[ $# -ne 3 ]] && die "Exactly 3 arguments are needed!"
	einfo "Looking in ${1} for new locales ..."
	pushd "${1}" >/dev/null || die "Cannot access ${1}"
	local current= x=
	for x in ${2}*${3} ; do
		x=${x#"${2}"}
		x=${x%"${3}"}
		current+="${x} "
	done
	popd >/dev/null
	if [[ ${PLOCALES} != ${current%[[:space:]]} ]] ; then
		einfo "There are changes in locales! This ebuild should be updated to:"
		einfo "PLOCALES=\"${current%[[:space:]]}\""
	fi
}

# @FUNCTION: l10n_get_linguas_crosssection
# @DESCRIPTION:
# Determine the cross-section of user-set LINGUAS and the locales which
# the package offers (listed in PLOCALES), and return them. In case no
# locales are selected, fall back on PLOCALE_BACKUP. This function is
# normally used internally in this eclass, not by l10n.eclass consumers.
l10n_get_linguas_crosssection() {
	local lang= loc= xloc=
	for lang in ${LINGUAS}; do
		for loc in ${PLOCALES}; do
			[[ ${lang} == ${loc} ]] && xloc+="${loc} "
		done
	done
	xloc=${xloc:-$PLOCALE_BACKUP}
	printf "%s" "${xloc}"
}
