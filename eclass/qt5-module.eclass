# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt5-module.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.
# Requires EAPI 4.

case ${EAPI} in
	4) : ;;
	*) die "qt5-module.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit eutils flag-o-matic multilib toolchain-funcs versionator

if [[ ${PV} == *9999* ]]; then
	QT5_BUILD_TYPE="live"
	inherit git-2
else
	QT5_BUILD_TYPE="release"
fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install src_test

HOMEPAGE="http://qt-project.org/ http://qt.nokia.com/"
LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="5"

EGIT_PROJECT=${PN/-}
case ${QT5_BUILD_TYPE} in
	live)
		EGIT_REPO_URI="git://gitorious.org/qt/${EGIT_PROJECT}.git
			https://git.gitorious.org/qt/${EGIT_PROJECT}.git"
		;;
	release)
		SRC_URI="" # TODO
		;;
esac

IUSE="debug test"

DEPEND="
	virtual/pkgconfig
	test? ( ~x11-libs/qt-test-${PV}[debug=] )
"
if [[ ${QT5_BUILD_TYPE} == "live" ]]; then
	DEPEND+=" dev-lang/perl"
fi

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing all the patches to be applied. This variable
# is expected to be defined in the global scope of ebuilds. Make sure to
# specify the full path. This variable is used in src_prepare phase.
#
# Example:
# @CODE
#	PATCHES=(
#		"${FILESDIR}/mypatch.patch"
#		"${FILESDIR}/mypatch2.patch"
#	)
# @CODE

# @ECLASS-VARIABLE: QT5_TARGET_SUBDIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing the source directories that should be built.
# All paths must be relative to ${S}.

# @ECLASS-VARIABLE: QT5_BUILD_DIR
# @DESCRIPTION:
# Build directory for out-of-source builds.
: ${QT5_BUILD_DIR:=${WORKDIR}/${P}_build}

# @ECLASS-VARIABLE: QCONFIG_ADD
# @DESCRIPTION:
# List of options that need to be added to QT_CONFIG in qconfig.pri
: ${QCONFIG_ADD:=}

# @ECLASS-VARIABLE: QCONFIG_REMOVE
# @DESCRIPTION:
# List of options that need to be removed from QT_CONFIG in qconfig.pri
: ${QCONFIG_REMOVE:=}

# @ECLASS-VARIABLE: QCONFIG_DEFINE
# @DESCRIPTION:
# List of variables that should be defined at the top of QtCore/qconfig.h
: ${QCONFIG_DEFINE:=}

# @FUNCTION: qt5-module_pkg_setup
# @DESCRIPTION:
# Warns and/or dies if the user is trying to downgrade Qt.
qt5-module_pkg_setup() {
	# Protect users by not allowing downgrades between releases.
	# Downgrading revisions within the same release should be allowed.
	if has_version ">${CATEGORY}/${P}-r9999:${SLOT}"; then
		if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
			eerror "    ***  Sanity check to keep you from breaking your system  ***"
			eerror "Downgrading Qt is completely unsupported and will break your system!"
			die "aborting to save your system"
		else
			ewarn "Downgrading Qt is completely unsupported and will break your system!"
		fi
	fi
}

# @FUNCTION: qt5-module_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt5-module_src_unpack() {
	if ! version_is_at_least 4.4 $(gcc-version); then
		ewarn "Using a GCC version lower than 4.4 is not supported."
	fi

	if [[ ${PN} == "qt-webkit" ]]; then
		eshopts_push -s extglob
		if is-flagq '-g?(gdb)?([1-9])'; then
			echo
			ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
			ewarn "You may experience really long compilation times and/or increased memory usage."
			ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
			ewarn "For more info check out https://bugs.gentoo.org/307861"
			echo
		fi
		eshopts_pop
	fi

	case ${QT5_BUILD_TYPE} in
		live)
			git-2_src_unpack
			;;
		release)
			default
			;;
	esac
}

# @FUNCTION: qt5-module_src_prepare
# @DESCRIPTION:
# Prepare the sources before the configure phase.
qt5-module_src_prepare() {
	qt5_prepare_env

	mkdir -p "${QT5_BUILD_DIR}" || die

	# Apply patches
	[[ -n ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user
}

# @FUNCTION: qt5-module_src_configure
# @DESCRIPTION:
# Runs ./configure and qmake.
qt5-module_src_configure() {
	# toolchain setup
	tc-export CC CXX RANLIB STRIP
	# qmake-generated Makefiles use LD/LINK for linking
	export LD="$(tc-getCXX)"

	pushd "${QT5_BUILD_DIR}" > /dev/null || die

	einfo "Running qmake"
	"${QTBINDIR}"/qmake \
		"${S}/${PN/-}.pro" \
		CONFIG+=nostrip \
		|| die "qmake failed"

	popd > /dev/null || die
}

# @FUNCTION: qt5-module_src_compile
# @DESCRIPTION:
# Compiles the code in target directories.
qt5-module_src_compile() {
	qt5_foreach_target_subdir emake
}

# @FUNCTION: qt5-module_src_test
# @DESCRIPTION:
# Runs tests in target directories.
# TODO: find a way to avoid circular deps with USE=test.
qt5-module_src_test() {
	echo ">>> Test phase [QtTest]: ${CATEGORY}/${PF}"

	# create a custom testrunner script that correctly sets
	# {,DY}LD_LIBRARY_PATH before executing the given test
	local testrunner=${QT5_BUILD_DIR}/gentoo-testrunner
	cat <<-EOF > "${testrunner}"
	#!/bin/sh
	export LD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QTLIBDIR}"
	export DYLD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QTLIBDIR}"
	"\$@"
	EOF
	chmod +x "${testrunner}"

	qmake() {
		"${QTBINDIR}"/qmake \
			"${S}/${subdir}/${subdir##*/}.pro" \
			|| die "qmake failed"
	}
	qt5_foreach_target_subdir qmake
	qt5_foreach_target_subdir emake
	qt5_foreach_target_subdir emake TESTRUNNER="'${testrunner}'" check
}

# @FUNCTION: qt5-module_src_install
# @DESCRIPTION:
# Performs the actual installation of target directories.
# TODO: pkgconfig files are installed in the wrong place
qt5-module_src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install

	# TODO: qt5_install_module_qconfigs

	# remove .la files since we are building only shared libraries
	prune_libtool_files
}

# @FUNCTION: qt_use
# @USAGE: <flag> [feature] [enableval]
# @DESCRIPTION:
# This will echo "-${enableval}-${feature}" if <flag> is enabled, or
# "-no-${feature}" if it's disabled. If [feature] is not specified,
# <flag> will be used for that. If [enableval] is not specified, the
# "-${enableval}" prefix is omitted.
qt_use() {
	use "$1" && echo "${3:+-$3}-${2:-$1}" || echo "-no-${2:-$1}"
}


######  Internal functions  ######

# @FUNCTION: qt5_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt5_prepare_env() {
	# setup installation directories
	QTPREFIXDIR=${EPREFIX}/usr
	QTBINDIR=${QTPREFIXDIR}/qt5/bin # FIXME
	QTLIBDIR=${QTPREFIXDIR}/$(get_libdir)/qt5
	QTDOCDIR=${QTPREFIXDIR}/share/doc/qt-${PV}
	QTHEADERDIR=${QTPREFIXDIR}/include/qt5
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTIMPORTDIR=${QTLIBDIR}/imports
	QTDATADIR=${QTPREFIXDIR}/share/qt5
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTTESTSDIR=${QTDATADIR}/tests
	QTSYSCONFDIR=${EPREFIX}/etc/qt5
}

# @FUNCTION: qt5_foreach_target_subdir
# @INTERNAL
# @DESCRIPTION:
# Executes the arguments inside each directory listed in QT5_TARGET_SUBDIRS.
qt5_foreach_target_subdir() {
	[[ -z ${QT5_TARGET_SUBDIRS[@]} ]] && QT5_TARGET_SUBDIRS=("")

	local subdir
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		if [[ ${EBUILD_PHASE} == "test" ]]; then
			subdir=tests/auto${subdir#src}
			[[ -d ${S}/${subdir} ]] || continue
		fi

		mkdir -p "${QT5_BUILD_DIR}/${subdir}" || die
		pushd "${QT5_BUILD_DIR}/${subdir}" > /dev/null || die

		einfo "Running $* ${subdir:+in ${subdir}}"
		"$@"

		popd > /dev/null || die
	done
}
