# Copyright 2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt4-edge.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>,
# Markos Chandras <hwoarang@gentoo.org>,
# Davide Pesavento <davidepesa@gmail.com>
# @BLURB: Experimental eclass for Qt4 packages
# @DESCRIPTION:
# This eclass contains various functions that may be useful
# when dealing with packages using Qt4 libraries.

inherit eutils multilib toolchain-funcs base

export XDG_CONFIG_HOME="${T}"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X%_*}"
done

for X in ${LANGSLONG}; do
	IUSE="${IUSE} linguas_${X}"
done

qt4-edge_pkg_setup() {
	case ${EAPI} in
		2) ;;
		*)
			eerror
			eerror "The ${ECLASS} eclass requires EAPI=2, but this ebuild does not"
			eerror "have EAPI=2 set. The ebuild author or editor failed. This ebuild needs"
			eerror "to be fixed. Using ${ECLASS} eclass without EAPI=2 will fail."
			eerror
			die "${ECLASS} eclass requires EAPI=2"
			;;
	esac
}

# @ECLASS-VARIABLE: PATCHES
# @DESCRIPTION:
# In case you have patches to apply, specify them in PATCHES variable. Make sure
# to specify the full path. This variable is necessary for src_prepare phase.
# example:
# PATCHES="${FILESDIR}"/mypatch.patch
# 	${FILESDIR}"/mypatch2.patch"
#
# @ECLASS-VARIABLE: LANGS
# @DESCRIPTION:
# In case your Qt4 provides various translations, use this variable to specify
# them. Make sure to set this variable BEFORE inheriting qt4-edge eclass.
# example: LANG="en el de"
#
# @ECLASS-VARIABLE: LANGSLONG
# @DESCRIPTION:
# Same as above, but this variable is for LINGUAS that must be in long format.
# Remember to set this variable BEFORE inheriting qt4-edge eclass.
# Look at ${PORTDIR}/profiles/desc/linguas.desc for details.
#
# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Use this variable if you want to install any documentation.
# example: DOCS="README AUTHORS"
#
# @ECLASS-VARIABLE: DOCSDIR
# @DESCRIPTION:
# Directory containing documentation. If not specified, ${S} will be used
# instead.
#
# @FUNCTION: qt4-edge_src_prepare
# @DESCRIPTION:
# Default src_prepare function for packages that depends on qt4. If you have to
# override src_prepare in your ebuild, you should call qt4_src_prepare in it,
# otherwise autopatcher will not work!
qt4-edge_src_prepare() {
	debug-print-function $FUNCNAME "$@"

	base_src_prepare
}

# @FUNCTION: qt4-edge_src_configure
# @DESCRIPTION:
# Default src_configure function for packages that depends on qt4. If you have to
# override src_configure in your ebuild, call qt4_src_configure in it.
qt4-edge_src_configure() {
	debug-print-function $FUNCNAME "$@"

	eqmake4
}

# @FUNCTION: qt4-edge_src_compile
# @DESCRIPTION:
# Default src_compile function for packages that depends on qt4. If you have to
# override src_compile in your ebuild (probably you don't need to), call
# qt4_src_compile in it.
qt4-edge_src_compile() {
	debug-print-function $FUNCNAME "$@"

	case "${EAPI}" in
		2)
			emake || die "emake failed"
			;;
		*)
			qt4_src_configure
			emake || die "emake failed"
			;;
	esac
}

# @FUNCTION: qt4-edge_src_install
# @DESCRIPTION:
# Default src_install function for qt4-based packages. Installs compiled code,
# documentation (via DOCS variable) and translations (via LANGS and
# LANGSLONG variables).
qt4-edge_src_install() {
	debug-print-function $FUNCNAME "$@"
	
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	# install documentation
	local dir=${DOCSDIR:-${S}}
	if [[ -n "${DOCS}" ]]; then
		for doc in ${DOCS}; do
			dodoc "${dir}/${doc}" || die "dodoc failed"
		done
	fi

	# install translations # hwoarang: Is this valid for every package???
	# need to have specified LANGS or LANGSLONG for this to work
	[[ -n "${LANGS}" || -n ${LANGSLONG} ]] && prepare_translations
}

# @FUNCTION: prepare_translations
# @DESCRIPTION:
# Choose and install translation files. Normally you don't need
# to call it directly at it is called from src_install function.
prepare_translations() {
	local LANG=
	local trans="${S}" dir=
	# Find translations directory
	for dir in lang langs translations; do
		[[ -d ${dir} ]] && trans="${dir}"
	done
	if [[ ${trans} == ${S} ]]; then
		insinto /usr/share/${PN}/
	else
		insinto /usr/share/${PN}/${trans}/
	fi
	for LANG in ${LINGUAS}; do
		for X in ${LANGS}; do
			if [[ ${LANG} == ${X%_*} ]]; then
				if [[ -e "${trans}"/${PN}_${X}.qm ]]; then	
					doins "${trans}"/${PN}_${X}.qm || die "failed to install translations"
				elif [[ -e "${trans}"/${X}.qm ]]; then
					doins "${trans}"/${X}.qm || die "failed to install translations"
				else
					eerror
					eerror "Failed to find translations. Contact eclass maintainer"
					eerror
					die
				fi
			fi
		done
		for X in ${LANGSLONG}; do
			if [[ ${LANG} == ${X} ]]; then
				if [[ -e "${trans}"/${PN}_${X}.qm ]]; then	
					doins "${trans}"/${PN}_${X}.qm || die "failed to install translations"
				elif [[ -e "${trans}"/${X}.qm ]]; then
					doins "${trans}"/${X}.qm || die "failed to install translations"
				else
					eerror
					eerror "Failed to find translations. Contact eclass maintainer"
					eerror
					die
				fi
			fi
		done
	done
}

# @FUNCTION: eqmake4
# @USAGE: [parameters to qmake]
# @DESCRIPTION:
# Wrapper for Qt4's qmake. All the arguments are appended unmodified to
# qmake command line. For recursive build systems, i.e. those based on
# the subdirs template, you should run eqmake4 on the top-level project
# file only, unless you have strong reasons to do things differently.
# During the building, qmake will be automatically re-invoked with the
# right arguments on every directory specified inside the top-level
# project file by the SUBDIRS variable.
eqmake4() {
	ebegin "Running qmake"

	# make sure CONFIG variable is correctly set for both release and debug builds
	local CONFIG_ADD="release"
	local CONFIG_REMOVE="debug"
	if has debug ${IUSE} && use debug; then
		CONFIG_ADD="debug"
		CONFIG_REMOVE="release"
	fi
	local awkscript='BEGIN {
				printf "### eqmake4 was here ###\n" > file;
				fixed=0;
			}
			/^[[:blank:]]*CONFIG[[:blank:]]*[\+\*]?=/ {
				for (i=1; i <= NF; i++) {
					if ($i ~ rem || $i ~ /debug_and_release/)
						{ $i=add; fixed=1; }
				}
			}
			/^[[:blank:]]*CONFIG[[:blank:]]*-=/ {
				for (i=1; i <= NF; i++) {
					if ($i ~ add) { $i=rem; fixed=1; }
				}
			}
			{
				print >> file;
			}
			END {
				printf "CONFIG -= debug_and_release %s\n", rem >> file;
				printf "CONFIG += %s\n", add >> file;
				print fixed;
			}'
	local file=
	while read file; do
		grep -q '^### eqmake4 was here ###$' "${file}" && continue
		local retval=$({
				rm -f "${file}" || echo "FAILED"
				awk -v file="${file}" -- "${awkscript}" add=${CONFIG_ADD} rem=${CONFIG_REMOVE} || echo "FAILED"
				} < "${file}")
		if [[ ${retval} == 1 ]]; then
			einfo " - fixed CONFIG in ${file}"
		elif [[ ${retval} != 0 ]]; then
			eerror "An error occurred while processing ${file}"
			die "eqmake4 failed to process '${file}'"
		fi
	done < <(find . -type f -name "*.pr[io]" -printf '%P\n' 2>/dev/null)

	/usr/bin/qmake -makefile -nocache \
		QTDIR=/usr/$(get_libdir) \
		QMAKE=/usr/bin/qmake \
		QMAKE_CC=$(tc-getCC) \
		QMAKE_CXX=$(tc-getCXX) \
		QMAKE_LINK=$(tc-getCXX) \
		QMAKE_CFLAGS_RELEASE="${CFLAGS}" \
		QMAKE_CFLAGS_DEBUG="${CFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_DEBUG="${CXXFLAGS}" \
		QMAKE_LFLAGS_RELEASE="${LDFLAGS}" \
		QMAKE_LFLAGS_DEBUG="${LDFLAGS}" \
		QMAKE_RPATH= \
		QMAKE_STRIP= \
		"${@}"

	# was qmake successful?
	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
		echo
		die "qmake failed"
	fi

	return 0
}

case ${EAPI} in
	2)
		EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile src_install
		;;
	*)
		EXPORT_FUNCTIONS pkg_setup src_compile src_install
		;;
esac
