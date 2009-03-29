# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/qt4.eclass,v 1.49 2008/09/21 01:21:09 yngwin Exp $

# @ECLASS: qt4.eclass
# @MAINTAINER:
# Caleb Tennis <caleb@gentoo.org>
# @BLURB: Eclass for Qt4 packages
# @DESCRIPTION:
# This eclass contains various functions that may be useful
# when dealing with packages using Qt4 libraries.

# 08.16.06 - Renamed qt_min_* to qt4_min_* to avoid conflicts with the qt3 eclass.
#    - Caleb Tennis <caleb@gentoo.org>

inherit eutils multilib toolchain-funcs base


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

# @FUNCTION: eqmake4
# @USAGE: [.pro file] [additional parameters to qmake]
# @MAINTAINER:
# Przemyslaw Maciag <troll@gentoo.org>
# Davide Pesavento <davidepesa@gmail.com>
# @DESCRIPTION:
# Runs qmake on the specified .pro file (defaults to
# ${PN}.pro if eqmake4 was called with no argument).
# Additional parameters are passed unmodified to qmake.
eqmake4() {
	local logfile="${T}/eqmake4-$$.log"
	local projectfile="${1:-${PN}.pro}"
	shift

	if [[ ! -f ${projectfile} ]]; then
		echo
		eerror "Project file '${projectfile}' does not exists!"
		eerror "eqmake4 cannot handle non-existing project files."
		eerror
		eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
		echo
		die "Project file not found in ${CATEGORY}/${PN} sources."
	fi

	ebegin "Running qmake on ${projectfile}"

	echo >> "${logfile}"
	echo "******  qmake ${projectfile}  ******" >> "${logfile}"
	echo >> "${logfile}"

	# make sure CONFIG variable is correctly set for both release and debug builds
	local CONFIG_ADD="release"
	local CONFIG_REMOVE="debug"
	if has debug ${IUSE} && use debug; then
		CONFIG_ADD="debug"
		CONFIG_REMOVE="release"
	fi
	local awkscript='BEGIN {
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
		local retval=$({
				rm -f "${file}"
				awk -- "${awkscript}" file="${file}" add=${CONFIG_ADD} rem=${CONFIG_REMOVE} \
					|| die "awk failed to process '${file}'."
				} < "${file}")
		if [[ ${retval} -eq 1 ]]; then
			einfo "  Fixed CONFIG in ${file}"
		elif [[ ${retval} -ne 0 ]]; then
			ewarn "  An error occurred while processing ${file}: awk script returned ${retval}"
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
		"${projectfile}" \
		"${@}" >> "${logfile}" 2>&1

	eend $?

	# was qmake successful?
	if [[ $? -ne 0 ]]; then
		echo
		eerror "Running qmake on '${projectfile}' has failed!"
		eerror
		eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
		eerror "A complete log of qmake output is located at '${logfile}'."
		echo
		die "qmake failed on '${projectfile}'."
	fi

	return 0
}

case ${EAPI} in
	2)
		EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile
		;;
	*)
		EXPORT_FUNCTIONS pkg_setup src_compile
		;;
esac
