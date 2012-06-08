# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt5-build.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.
# eutils, flag-o-matic, multilib eclasses are guaranteed to be already inherited.
# Requires EAPI 4.

case ${EAPI} in
	4)	: ;;
	*)	die "qt5-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit base eutils flag-o-matic multilib toolchain-funcs versionator

if [[ ${PV} == *9999* ]]; then
	QT5_BUILD_TYPE="live"
	inherit git-2
else
	QT5_BUILD_TYPE="release"
fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install src_test pkg_postinst pkg_postrm

HOMEPAGE="http://qt-project.org/ http://qt.nokia.com/"
LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="5"

case ${PN#qt-} in
	core|dbus|gui|network|sql|test|xml)	EGIT_PROJECT="qtbase" ;;
	3d|jsbackend|script|svg|xmlpatterns)	EGIT_PROJECT="${PN/-}" ;;
	*) die "qt5-build.eclass: unknown module ${PN}" ;;
esac
case ${QT5_BUILD_TYPE} in
	live)
		EGIT_REPO_URI="git://gitorious.org/qt/${EGIT_PROJECT}.git
			https://git.gitorious.org/qt/${EGIT_PROJECT}.git"
		;;
	release)
		SRC_URI="" # TODO
esac

IUSE="+c++11 debug +pch"

DEPEND="virtual/pkgconfig"
if [[ ${QT5_BUILD_TYPE} == live ]]; then
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

# @ECLASS-VARIABLE: QT5_VERBOSE_CONFIGURE
# @DESCRIPTION:
# Set to false to suppress printing of detailed information
# about each step of the configure process.
: ${QT5_VERBOSE_CONFIGURE:=true}

# @ECLASS-VARIABLE: QT5_VERBOSE_BUILD
# @DESCRIPTION:
# Set to false to reduce build output during compilation.
: ${QT5_VERBOSE_BUILD:=true}

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

# @FUNCTION: qt5-build_pkg_setup
# @DESCRIPTION:
# Warns and/or dies if the user is trying to downgrade Qt.
qt5-build_pkg_setup() {
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

# @FUNCTION: qt5-build_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt5-build_src_unpack() {
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

# @FUNCTION: qt5-build_src_prepare
# @DESCRIPTION:
# Prepare the sources before the configure phase.
qt5-build_src_prepare() {
	qt5_prepare_env

	mkdir -p "${QT5_BUILD_DIR}" || die

	if [[ ${PN} != "qt-core" ]]; then
		symlink_tools_to_buildtree
	fi

	# Avoid unnecessary qmake recompilations
	sed -i -re "s|^if true;.*(\[ '\!').*(\"\\\$outpath/bin/qmake\".*)|if \1 -e \2 then|" \
		configure || die "sed configure failed"

	# Respect CC, CXX, *FLAGS, MAKEOPTS and EXTRA_EMAKE when building qmake
	sed -i -e "/\"\$MAKE\".*QMAKE_BUILD_ERROR/ s:): \
		${MAKEOPTS} ${EXTRA_EMAKE} \
		'CC=$(tc-getCC)' 'CXX=$(tc-getCXX)' \
		'QMAKE_CFLAGS=${CFLAGS}' 'QMAKE_CXXFLAGS=${CXXFLAGS}' 'QMAKE_LFLAGS=${LDFLAGS}'&:" \
		configure || die "sed configure failed"

	# Respect CC, CXX, LINK and *FLAGS in config.tests
	find config.tests/unix -name '*.test' -type f -print0 | xargs -0 \
		sed -i -e "/bin\/qmake/ s: \"QT_BUILD_TREE=: \
			'QMAKE_CC=$(tc-getCC)'    'QMAKE_CXX=$(tc-getCXX)'      'QMAKE_LINK=$(tc-getCXX)' \
			'QMAKE_CFLAGS+=${CFLAGS}' 'QMAKE_CXXFLAGS+=${CXXFLAGS}' 'QMAKE_LFLAGS+=${LDFLAGS}'&:" \
		|| die "sed config.tests failed"

	# TODO
	# in compile.test, -m flags are passed to the linker via LIBS
	# config tests that use $COMPILER directly ignore toolchain

	# Respect C/C++ compiler
	tc-export CC CXX
	# qmake-generated Makefiles use LD/LINK for linking
	export LD="$(tc-getCXX)"
	# Don't strip binaries
	export STRIP=":"

	base_src_prepare
}

# @FUNCTION: qt5-build_src_configure
# @DESCRIPTION:
# Default configure phase.
qt5-build_src_configure() {
	# configure arguments
	local conf=(
		# installation paths
		-prefix "${QTPREFIXDIR}"
		-bindir "${QTBINDIR}"
		-libdir "${QTLIBDIR}"
		-docdir "${QTDOCDIR}"
		-headerdir "${QTHEADERDIR}"
		-plugindir "${QTPLUGINDIR}"
		-importdir "${QTIMPORTDIR}"
		-datadir "${QTDATADIR}"
		-translationdir "${QTTRANSDIR}"
		-sysconfdir "${QTSYSCONFDIR}"
		-examplesdir "${QTEXAMPLESDIR}"
		-testsdir "${QTTESTSDIR}"

		# debug/release
		$(use debug && echo -debug || echo -release)
		-no-separate-debug-info

		# licensing stuff
		-opensource -confirm-license

		# C++11 support
		$(qt_use c++11)

		# general configure options
		-shared -fast -largefile
		-pkg-config
		-system-zlib -system-pcre

		# don't build examples
		-nomake examples

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(use prefix || echo -no-rpath)

		# verbosity of the configure and build phases
		$(${QT5_VERBOSE_CONFIGURE} && echo -verbose)
		$(${QT5_VERBOSE_BUILD} || echo -silent)

		# precompiled headers don't work on hardened, where the flag is masked
		$(qt_use pch)

		# reduce relocations in libraries through extra linker optimizations
		# requires GNU ld >= 2.18
		-reduce-relocations

		# freetype2 include dir is non-standard
		# FIXME: move to qt-gui ebuild?
		$($(tc-getPKG_CONFIG) --cflags-only-I freetype2 2>/dev/null)

		# package-specific options
		"${myconf[@]}"
	)

	pushd "${QT5_BUILD_DIR}" >/dev/null || die
	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"
	popd >/dev/null || die

	if [[ ${PN} != "qt-core" ]]; then
		local subdir
		for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
			pushd "${QT5_BUILD_DIR}/${subdir}" >/dev/null || die
			einfo "Running qmake in: ${subdir}"
			"${QT5_BUILD_DIR}"/bin/qmake \
				"${S}/${subdir}/${subdir##*/}.pro" \
				QMAKE_LIBDIR_QT="${QTLIBDIR}" \
				|| die "qmake failed in ${subdir}"
			popd >/dev/null || die
		done
	fi
}

# @FUNCTION: qt5-build_src_compile
# @DESCRIPTION:
# Compiles the code in QT5_TARGET_SUBDIRS.
qt5-build_src_compile() {
	local subdir
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		pushd "${QT5_BUILD_DIR}/${subdir}" >/dev/null || die
		einfo "Building in: ${subdir}"
		emake
		popd >/dev/null || die
	done
}

# @FUNCTION: qt5-build_src_test
# @DESCRIPTION:
# Runs tests in target directories.
qt5-build_src_test() {
	# TODO
	:
}

# @FUNCTION: qt5-build_src_install
# @DESCRIPTION:
# Perform the actual installation including some library fixes.
qt5-build_src_install() {
	local subdir
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		pushd "${QT5_BUILD_DIR}/${subdir}" >/dev/null || die
		emake INSTALL_ROOT="${D}" install
		popd >/dev/null || die
	done

	# TODO: install_qconfigs
	# TODO: pkgconfig files are installed in the wrong place

	# remove .la files since we are building only shared Qt libraries
	prune_libtool_files --all
}

# @FUNCTION: qt5-build_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration, plus throw a message about possible
# breakages and proposed solutions.
qt5-build_pkg_postinst() {
	# TODO
	#generate_qconfigs
	:
}

# @FUNCTION: qt5-build_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when the package is completely removed.
qt5-build_pkg_postrm() {
	# TODO
	#generate_qconfigs
	:
}

# @FUNCTION: qt_use
# @USAGE: < flag > [ feature ] [ enableval ]
# @DESCRIPTION:
# This will echo "-${enableval}-${feature}" if <flag> is enabled, or
# "-no-${feature}" if it's disabled. If [feature] is not specified, <flag>
# will be used for that. If [enableval] is not specified, it omits the
# "-${enableval}" part.
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
	QTBINDIR=${EPREFIX}/usr/qt5/bin # FIXME
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

# @FUNCTION: symlink_tools_to_buildtree
# @INTERNAL
# @DESCRIPTION:
# Symlinks qt-core tools to buildtree, so they can be used when building other modules.
symlink_tools_to_buildtree() {
	mkdir -p "${QT5_BUILD_DIR}"/bin || die

	local bin
	for bin in "${QTBINDIR}"/{qmake,moc,rcc}; do
		ln -s "${bin}" "${QT5_BUILD_DIR}"/bin/ \
			|| die "symlinking '${bin}' to '${QT5_BUILD_DIR}/bin/' failed"
	done
}

# @FUNCTION: install_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Installs gentoo-specific mkspecs configurations.
install_qconfigs() {
	local x

	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} ]]; then
		for x in QCONFIG_ADD QCONFIG_REMOVE; do
			[[ -n ${!x} ]] && echo ${x}=${!x} >> "${T}"/${PN}-qconfig.pri
		done
		insinto ${QTDATADIR#${EPREFIX}}/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri || die "installing ${PN}-qconfig.pri failed"
	fi

	if [[ -n ${QCONFIG_DEFINE} ]]; then
		for x in ${QCONFIG_DEFINE}; do
			echo "#define ${x}" >> "${T}"/gentoo-${PN}-qconfig.h
		done
		insinto ${QTHEADERDIR#${EPREFIX}}/Gentoo
		doins "${T}"/gentoo-${PN}-qconfig.h || die "installing ${PN}-qconfig.h failed"
	fi
}

# @FUNCTION: generate_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Generates gentoo-specific qconfig.{h,pri}.
generate_qconfigs() {
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} || -n ${QCONFIG_DEFINE} ]]; then
		local x qconfig_add qconfig_remove qconfig_new
		for x in "${ROOT}${QTDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			[[ -f ${x} ]] || continue
			qconfig_add+=" $(sed -n 's/^QCONFIG_ADD=//p' "${x}")"
			qconfig_remove+=" $(sed -n 's/^QCONFIG_REMOVE=//p' "${x}")"
		done

		# these error checks do not use die because dying in pkg_post{inst,rm}
		# just makes things worse.
		if [[ -e "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qconfig.pri ]]; then
			# start with the qconfig.pri that qt-core installed
			if ! cp "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qconfig.pri \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri; then
				eerror "cp qconfig failed."
				return 1
			fi

			# generate list of QT_CONFIG entries from the existing list
			# including qconfig_add and excluding qconfig_remove
			for x in $(sed -n 's/^QT_CONFIG +=//p' \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri) ${qconfig_add}; do
					has ${x} ${qconfig_remove} || qconfig_new+=" ${x}"
			done

			# replace the existing QT_CONFIG list with qconfig_new
			if ! sed -i -e "s/QT_CONFIG +=.*/QT_CONFIG += ${qconfig_new}/" \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri; then
				eerror "Sed for QT_CONFIG failed"
				return 1
			fi

			# create Gentoo/qconfig.h
			if [[ ! -e ${ROOT}${QTHEADERDIR}/Gentoo ]]; then
				if ! mkdir -p "${ROOT}${QTHEADERDIR}"/Gentoo; then
					eerror "mkdir ${QTHEADERDIR}/Gentoo failed"
					return 1
				fi
			fi
			: > "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h
			for x in "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-*-qconfig.h; do
				[[ -f ${x} ]] || continue
				cat "${x}" >> "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h
			done
		else
			rm -f "${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri
			rm -f "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h
			rmdir "${ROOT}${QTDATADIR}"/mkspecs \
				"${ROOT}${QTDATADIR}" \
				"${ROOT}${QTHEADERDIR}"/Gentoo \
				"${ROOT}${QTHEADERDIR}" 2>/dev/null
		fi
	fi
}
