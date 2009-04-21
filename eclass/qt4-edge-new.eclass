# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/qt4.eclass,v 1.49 2008/09/21 01:21:09 yngwin Exp $

# @ECLASS: qt4.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>,
# Markos Chandras <hwoarang@gentoo.org>,
# Caleb Tennis <caleb@gentoo.org>,
# Przemyslaw Maciag <troll@gentoo.org>,
# Davide Pesavento <davidepesa@gmail.com>
# @BLURB: Eclass for Qt4 packages
# @DESCRIPTION:
# This eclass contains various functions that may be useful
# when dealing with packages using Qt4 libraries.

inherit eutils multilib toolchain-funcs base

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X%_*}"
done

for X in ${LANGSLONG};do
	IUSE="${IUSE} linguas_${X}"
done

qt4-edge_pkg_setup() {
	case ${EAPI} in
		2) : ;;
		*) ewarn "The qt4-edge eclass requires EAPI=2, but this ebuild does not"
	       ewarn "have EAPI=2 set. The ebuild author or editor failed. This ebuild needs"
	       ewarn "to be fixed. Using qt4-edge eclass without EAPI=2 will fail."
	       die "qt4-edge eclass requires EAPI=2 set";;

	esac
}

# @ECLASS-VARIABLE: PATCHES
# @DESCRIPTION:
# In case you have pathes to apply , specify them on PATCHES variable. Make sure
# to specify the full path, Thjs variable is necessary for src_prepare phase.
# example:
# PATCHES="${FILESDIR}"/mypatch.patch
# 	${FILESDIR}"/mypatch2.patch"
#
# @ECLASS-VARIABLE: LANGS
# @DESCRIPTION:
# In case your Qt4 provides various translations, use this variable to specify
# them
# example: LANG="en el de"
#
# @ECLASS-VARIABLE: LANGSLONG
# @DESCRIPTION:
# Same as above, but this variable is for LINGUAS that must be in long format
# Look at ${PORTDIR}/profiles/desc/linguas.desc for details
#
# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Use this variable if you want to install any documentation.
# example: DOCS="README AUTHORS"
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
# documentation ( via DOCS variabled ) and translations ( via LANGS and
# LANGSLONG ) variables

qt4-edge_src_install() {
	debug-print-functions $FUNCNAME "$@"

	emake INSTALL_ROOT="${D}" install

	# install documentation
	[[ -n "${DOCS}" ]] && { dodoc ${DOCS} || die "dodoc failed" ; }

	# install translations # hwoarang: Is this valid for every package???
	insinto /usr/share/${PN}/translations/
	local LANG=
	for LANG in ${LINGUAS};do
		for X in ${LANGS};do
			if [[ ${LANG} == ${X%_*} ]];then
				doins -r lang/${X}.qm || die "failed to install translations"
			fi
		done
		for	X in ${LANGSLONG};do
			if	[[ ${LANG} == ${X} ]];then
				doins -r lang/${X}.qm || die "failed to	install translations"
			fi
		done
	done
}

# @FUNCTION: eqmake4
# @USAGE: [.pro file] [additional parameters to qmake]
# @DESCRIPTION:
# Runs qmake on the specified .pro file (defaults to
# ${PN}.pro if eqmake4 was called with no argument).
# Additional parameters are passed unmodified to qmake.
eqmake4() {
	local projectfile="${1:-${PN}.pro}"
	shift

	if [[ ! -f ${projectfile} ]]; then
		echo
		eerror "Project file '${projectfile#${WORKDIR}/}' does not exists!"
		eerror "eqmake4 cannot handle non-existing project files."
		eerror
		eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
		echo
		die "Project file not found in ${CATEGORY}/${PN} sources."
	fi

	ebegin "Running qmake on ${projectfile}"

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
			einfo "  Fixed CONFIG in ${file}"
		elif [[ ${retval} != 0 ]]; then
			eerror "  An error occurred while processing ${file}"
			die "eqmake4 failed to process '${file}'."
		fi
	done < <(find "$(dirname "${projectfile}")" -type f -name "*.pr[io]" -printf '%P\n' 2>/dev/null)

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
		"${projectfile}" "${@}"

	eend $?

	# was qmake successful?
	if [[ $? -ne 0 ]]; then
		echo
		eerror "Running qmake on '${projectfile#${WORKDIR}/}' has failed!"
		eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
		echo
		die "qmake failed on '${projectfile}'."
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
