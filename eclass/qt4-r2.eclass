# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt4-r2.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @BLURB: Eclass for Qt4-based packages, second edition.
# @DESCRIPTION:
# This eclass contains various functions that may be useful when
# dealing with packages using Qt4 libraries. Requires EAPI=2 or later.

case ${EAPI} in
	2|3|4)	: ;;
	*)	die "EAPI=${EAPI} is not supported by ${ECLASS} eclass." ;;
esac

inherit base eutils multilib toolchain-funcs

export XDG_CONFIG_HOME="${T}"

# @ECLASS-VARIABLE: LANGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# In case your Qt4 application provides various translations, use this variable
# to specify them in order to populate "linguas_*" IUSE automatically. Make sure
# that you set this variable before inheriting qt4-r2 eclass.
# Example:
# @CODE
#   LANGS="en el de"
# @CODE
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

# @ECLASS-VARIABLE: LANGSLONG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Same as above, but this variable is for LINGUAS that must be in long format.
# Remember to set this variable before inheriting qt4-r2 eclass.
# Look at ${PORTDIR}/profiles/desc/linguas.desc for details.
for x in ${LANGSLONG}; do
	IUSE+=" linguas_${x%_*}"
done
unset x

# @FUNCTION: qt4-r2_src_unpack
# @DESCRIPTION:
# Default src_unpack function for packages that depend on qt4. If you have to
# override src_unpack in your ebuild (probably you don't need to), call
# qt4-r2_src_unpack in it.
qt4-r2_src_unpack() {
	debug-print-function $FUNCNAME "$@"

	# remove this block before pushing updates to the tree
	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		ewarn
		ewarn "Please file bugs on bugs.gentoo.org and prepend the summary with"
		ewarn "[qt overlay]. Alternatively, contact qt@gentoo.org."
		ewarn "Thank you for using qt overlay."
		ewarn
	fi

	base_src_unpack "$@"
}

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# In case you have patches to apply, specify them here. Make sure to
# specify the full path. This variable is used in src_prepare phase.
# Example:
# @CODE
#   PATCHES=( "${FILESDIR}"/mypatch.patch
#             "${FILESDIR}"/mypatch2.patch )
# @CODE

# @FUNCTION: qt4-r2_src_prepare
# @DESCRIPTION:
# Default src_prepare function for packages that depend on qt4. If you have to
# override src_prepare in your ebuild, you should call qt4-r2_src_prepare in it,
# otherwise autopatcher will not work!
qt4-r2_src_prepare() {
	debug-print-function $FUNCNAME "$@"

	base_src_prepare "$@"
}

# @FUNCTION: qt4-r2_src_configure
# @DESCRIPTION:
# Default src_configure function for packages that depend on qt4. If you have to
# override src_configure in your ebuild, call qt4-r2_src_configure in it.
qt4-r2_src_configure() {
	debug-print-function $FUNCNAME "$@"

	local project_file=$(_find_project_file)

	if [[ -n ${project_file} ]]; then
		eqmake4 "${project_file}"
	else
		base_src_configure "$@"
	fi
}

# @FUNCTION: qt4-r2_src_compile
# @DESCRIPTION:
# Default src_compile function for packages that depend on qt4. If you have to
# override src_compile in your ebuild (probably you don't need to), call
# qt4-r2_src_compile in it.
qt4-r2_src_compile() {
	debug-print-function $FUNCNAME "$@"

	base_src_compile "$@"
}

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Use this variable if you want to install any documentation.
# Example:
# @CODE
#   DOCS="README AUTHORS"
# @CODE

# @ECLASS-VARIABLE: DOCSDIR
# @DESCRIPTION:
# Directory containing documentation, defaults to ${S}.

# @FUNCTION: qt4-r2_src_install
# @DESCRIPTION:
# Default src_install function for qt4-based packages. Installs compiled code,
# documentation (via DOCS variable) and translations (via LANGS and
# LANGSLONG variables).
qt4-r2_src_install() {
	debug-print-function $FUNCNAME "$@"

	emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "emake install failed"

	# install documentation
	local doc= dir=${DOCSDIR:-${S}}
	for doc in ${DOCS}; do
		dodoc "${dir}/${doc}" || die "dodoc failed"
	done

	# install translations # hwoarang: Is this valid for every package???
	# need to have specified LANGS or LANGSLONG for this to work
	[[ -n ${LANGS} || -n ${LANGSLONG} ]] && prepare_translations
}

# Internal function, used by eqmake4 and qt4-r2_src_configure
# Look for project files:
#   0 *.pro files found - output null string
#   1 *.pro file found - output its name
#   2 or more *.pro files found - if ${PN}.pro or $(basename ${S}).pro
#     are there, output any of them
# Outputs a project file argument used by eqmake4. Sets nullglob locally
# to avoid expanding *.pro as "*.pro" when there are no matching files.
_find_project_file() {
	local dir_name=$(basename "${S}")

	eshopts_push -s nullglob
	local pro_files=(*.pro)
	eshopts_pop

	case ${#pro_files[@]} in
	1)
		echo "${pro_files[0]}"
		;;
	*)
		for pro_file in "${pro_files[@]}"; do
			if [[ ${pro_file} == "${dir_name}.pro" || ${pro_file} == "${PN}.pro" ]]; then
				echo "${pro_file}"
				break
			fi
		done
		;;
	esac
}

# @FUNCTION: eqmake4
# @USAGE: [project_file] [parameters to qmake]
# @DESCRIPTION:
# Wrapper for Qt4's qmake. If project_file isn't specified, eqmake4 will
# look for it in the current directory (${S}, non-recursively). If more
# than one project file are found, then ${PN}.pro is processed, provided
# that it exists. Otherwise eqmake4 fails.
#
# All other arguments are appended unmodified to qmake command line. For
# recursive build systems, i.e. those based on the subdirs template, you
# should run eqmake4 on the top-level project file only, unless you have
# strong reasons to do things differently. During the building, qmake
# will be automatically re-invoked with the right arguments on every
# directory specified inside the top-level project file.
eqmake4() {
	[[ ${EAPI} == 2 ]] && use !prefix && EPREFIX=

	ebegin "Running qmake"

	local qmake_args=("$@")

	# check if project file was passed as a first argument
	# if not, then search for it
	local regexp='.*\.pro'
	if ! [[ ${1} =~ ${regexp} ]]; then
		local project_file=$(_find_project_file)
		if [[ -z ${project_file} ]]; then
			echo
			eerror "No project files found in '${PWD}'!"
			eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
			echo
			die "eqmake4 failed"
		fi
		qmake_args+=("${project_file}")
	fi

	# make sure CONFIG variable is correctly set
	# for both release and debug builds
	local config_add="release"
	local config_remove="debug"
	if has debug ${IUSE} && use debug; then
		config_add="debug"
		config_remove="release"
	fi
	local awkscript='BEGIN {
				printf "### eqmake4 was here ###\n" > file;
				printf "CONFIG -= debug_and_release %s\n", remove >> file;
				printf "CONFIG += %s\n\n", add >> file;
				fixed=0;
			}
			/^[[:blank:]]*CONFIG[[:blank:]]*[\+\*]?=/ {
				if (gsub("\\<((" remove ")|(debug_and_release))\\>", "") > 0) {
					fixed=1;
				}
			}
			/^[[:blank:]]*CONFIG[[:blank:]]*-=/ {
				if (gsub("\\<" add "\\>", "") > 0) {
					fixed=1;
				}
			}
			{
				print >> file;
			}
			END {
				print fixed;
			}'
	local file=
	while read file; do
		grep -q '^### eqmake4 was here ###$' "${file}" && continue
		local retval=$({
				rm -f "${file}" || echo FAIL
				awk -v file="${file}" \
					-v add=${config_add} \
					-v remove=${config_remove} \
					-- "${awkscript}" || echo FAIL
				} < "${file}")
		if [[ ${retval} == 1 ]]; then
			einfo " - fixed CONFIG in ${file}"
		elif [[ ${retval} != 0 ]]; then
			eerror " - error while processing ${file}"
			die "eqmake4 failed to process ${file}"
		fi
	done < <(find . -type f -name '*.pr[io]' -printf '%P\n' 2>/dev/null)

	"${EPREFIX}"/usr/bin/qmake \
		-makefile \
		QTDIR="${EPREFIX}"/usr/$(get_libdir) \
		QMAKE="${EPREFIX}"/usr/bin/qmake \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		QMAKE_LIBDIR_QT="${EPREFIX}"/usr/$(get_libdir)/qt4 \
		QMAKE_LIBDIR_X11="${EPREFIX}"/usr/$(get_libdir) \
		QMAKE_LIBDIR_OPENGL="${EPREFIX}"/usr/$(get_libdir) \
		QMAKE_STRIP= \
		"${qmake_args[@]}"

	# was qmake successful?
	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to http://bugs.gentoo.org/"
		echo
		die "eqmake4 failed"
	fi

	return 0
}

# Internal function
_do_qm() {
	debug-print-function $FUNCNAME "$@"
	[[ $# -ne 2 ]] && die "$FUNCNAME requires exactly 2 arguments!"

	local transfile="$(find "${1}" -type f -name "*${2}".qm)"
	if [[ -f ${transfile} ]]; then
		(
			insinto /usr/share/${PN}/"${1#${S}}"
			doins "${transfile}"
		) || die "failed to install ${2} translation"
	else
		eerror
		eerror "Failed to install ${2} translation: file not found."
		eerror
		die "failed to install ${2} translation"
	fi
}

# @VARIABLE: TRANSLATIONSDIR
# @DESCRIPTION: Translations directory. If not set, ${S} will be used

# @FUNCTION: prepare_translations
# @DESCRIPTION:
# Choose and install translation files. Normally you don't need to call
# this function directly as it is called from qt4-r2_src_install.
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

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install
