# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt4-edge.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>,
# Markos Chandras <hwoarang@gentoo.org>,
# Davide Pesavento <davidepesa@gmail.com>,
# Dominik Kapusta <ayoy@gentoo.org>
# @BLURB: Experimental eclass for Qt4 packages
# @DESCRIPTION:
# This eclass contains various functions that may be useful when
# dealing with packages using Qt4 libraries. Requires EAPI=2.

inherit base eutils multilib qt4-r2 toolchain-funcs

export XDG_CONFIG_HOME="${T}"

qt4-edge_pkg_setup() {
	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		ewarn
		ewarn "Please file bugs on bugs.gentoo.org and prepend the summary with"
		ewarn "[qting-edge]. Alternatively, contact qt@gentoo.org."
		ewarn "Thank you for using qting-edge overlay."
		ewarn
		ebeep 5
	fi
}

qt4-edge_src_unpack() {
	debug-print-function $FUNCNAME "$@"

	qt4-r2_src_unpack "$@"
}

# @FUNCTION: qt4-edge_src_prepare
# @DESCRIPTION:
# Default src_prepare function for packages that depend on qt4. If you have to
# override src_prepare in your ebuild, you should call qt4-edge_src_prepare in it,
# otherwise autopatcher will not work!
qt4-edge_src_prepare() {
	debug-print-function $FUNCNAME "$@"

	qt4-r2_src_prepare
}

# @FUNCTION: qt4-edge_src_configure
# @DESCRIPTION:
# Default src_configure function for packages that depends on qt4. If you have to
# override src_configure in your ebuild, call qt4-edge_src_configure in it.
qt4-edge_src_configure() {
	debug-print-function $FUNCNAME "$@"

	qt4-r2_src_configure
}

# @FUNCTION: qt4-edge_src_compile
# @DESCRIPTION:
# Default src_compile function for packages that depends on qt4. If you have to
# override src_compile in your ebuild (probably you don't need to), call
# qt4-edge_src_compile in it.
qt4-edge_src_compile() {
	debug-print-function $FUNCNAME "$@"

	qt4-r2_src_compile
}

# @FUNCTION: qt4-edge_src_install
# @DESCRIPTION:
# Default src_install function for qt4-based packages. Installs compiled code,
# documentation (via DOCS variable) and translations (via LANGS and
# LANGSLONG variables).
qt4-edge_src_install() {
	debug-print-function $FUNCNAME "$@"

	qt4-r2_src_install

	# install translations # hwoarang: Is this valid for every package???
	# need to have specified LANGS or LANGSLONG for this to work
	[[ -n "${LANGS}" || -n "${LANGSLONG}" ]] && prepare_translations
}

# Internal function
_do_qm() {
	debug-print-function $FUNCNAME "$@"
	[[ $# -ne 2 ]] && die "$FUNCNAME requires exactly 2 arguments!"

	local transfile="$(find "${1}" -type f -name "*${2}".qm)"
	if [[ -e ${transfile} ]]; then
		INSDESTTREE="/usr/share/${PN}/${1#${S}}" \
			doins "${transfile}" \
			|| die "failed to install ${2} translation"
	else
		eerror
		eerror "Failed to install ${2} translation. Contact eclass maintainer."
		eerror
		die "Failed to install translations"
	fi
}

# @VARIABLE: TRANSLATIONSDIR
# @DESCRIPTION: Translations directory. If not set, ${S} will be used

# @FUNCTION: prepare_translations
# @DESCRIPTION:
# Choose and install translation files. Normally you don't need to call
# this function directly as it is called from qt4-edge_src_install.
prepare_translations() {
	debug-print-function $FUNCNAME "$@"

	# Find translations directory
	# Changed default to . - crazy upstreams :)
	local roottrdir="${TRANSLATIONSDIR:-${S}}" trdir=.
	for dir in lang langs translations; do
		[[ -d ${roottrdir}/${dir} ]] && trdir="${roottrdir}/${dir}"
	done

	local lang=
	for lang in ${LINGUAS}; do
		for x in ${LANGS}; do
			[[ ${lang} == ${x%_*} ]] && _do_qm "${trdir}" ${x}
		done
		for x in ${LANGSLONG}; do
			[[ ${lang} == ${x} ]] && _do_qm "${trdir}" ${x}
		done
	done
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install
