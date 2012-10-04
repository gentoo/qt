# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt5-build.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.
# Requires EAPI 4.

case ${EAPI} in
	4|5)	: ;;
	*)	die "qt5-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit eutils flag-o-matic multilib toolchain-funcs versionator

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
	core|dbus|gui|network|opengl|printsupport|sql|test|widgets|xml)
		EGIT_PROJECT="qtbase"
		;;
	*)
		EGIT_PROJECT="${PN/-}"
		;;
esac
case ${QT5_BUILD_TYPE} in
	live)
		MY_P=${P}
		EGIT_REPO_URI="git://gitorious.org/qt/${EGIT_PROJECT}.git
			https://git.gitorious.org/qt/${EGIT_PROJECT}.git"
		;;
	release)
		MY_P=${EGIT_PROJECT}-opensource-src-${PV/_/-}
		SRC_URI="http://releases.qt-project.org/qt${PV%.*}/${PV#*_}/split_sources/${MY_P}.tar.xz"
		;;
esac

IUSE="+c++11 debug test"
if [[ ${EGIT_PROJECT} == "qtbase" ]]; then
	IUSE+=" +pch"
fi

DEPEND=">=dev-lang/perl-5.10
	virtual/pkgconfig"
if [[ ${PN} != "qt-test" ]]; then
	DEPEND+=" test? ( ~x11-libs/qt-test-${PV}[debug=] )"
fi

S=${WORKDIR}/${MY_P}

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
: ${QT5_BUILD_DIR:=${WORKDIR}/${MY_P}_build}

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
	# Warn users of possible breakage when downgrading to a previous release.
	# Downgrading revisions within the same release is safe.
	if has_version ">${CATEGORY}/${P}-r9999:${SLOT}"; then
		ewarn
		ewarn "Downgrading Qt is completely unsupported and can break your system!"
		ewarn
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
# Prepares the sources before the configure phase.
qt5-build_src_prepare() {
	qt5_prepare_env

	mkdir -p "${QT5_BUILD_DIR}" || die

	if [[ ${EGIT_PROJECT} == "qtbase" ]]; then
		if [[ ${PN} == "qt-core" ]]; then
			# Respect CC, CXX, *FLAGS, MAKEOPTS and EXTRA_EMAKE when building qmake
			# FIXME: see bug 434780
			sed -i -e "/outpath\/qmake\".*\"\$MAKE\")/ s:): \
				${MAKEOPTS} ${EXTRA_EMAKE} \
				'CC=$(tc-getCC)' 'CXX=$(tc-getCXX)' \
				'QMAKE_CFLAGS=${CFLAGS}' 'QMAKE_CXXFLAGS=${CXXFLAGS}' 'QMAKE_LFLAGS=${LDFLAGS}'&:" \
				configure || die "sed qmake build failed"
		else
			# Skip qmake build
			sed -i -e '/outpath\/qmake".*"$MAKE")/ d' \
				configure || die "sed qmake build failed"
			rm -f qmake/Makefile*
		fi

		# Respect CXX in configure
		sed -i -e "/^QMAKE_CONF_COMPILER=/ s:=.*:=\"$(tc-getCXX)\":" \
			configure || die "sed QMAKE_CONF_COMPILER failed"

		# Respect CC, CXX, LINK and *FLAGS in config.tests
		# FIXME: in compile.test, -m flags are passed to the linker via LIBS
		find config.tests/unix -name '*.test' -type f -print0 | xargs -0 \
			sed -i -e "/bin\/qmake/ s: \"QT_BUILD_TREE=: \
				'QMAKE_CC=$(tc-getCC)'    'QMAKE_CXX=$(tc-getCXX)'      'QMAKE_LINK=$(tc-getCXX)' \
				'QMAKE_CFLAGS+=${CFLAGS}' 'QMAKE_CXXFLAGS+=${CXXFLAGS}' 'QMAKE_LFLAGS+=${LDFLAGS}'&:" \
			|| die "sed config.tests failed"
	fi

	if [[ ${PN} != "qt-core" ]]; then
		qt5_symlink_tools_to_buildtree
	fi

	# Remove unused project files to speed up recursive qmake invocation
	rm -f demos/demos.pro examples/examples.pro tests/tests.pro

	# Apply patches
	[[ -n ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user
}

# @FUNCTION: qt5-build_src_configure
# @DESCRIPTION:
# Runs qmake, possibly preceded by ./configure.
qt5-build_src_configure() {
	# toolchain setup
	tc-export CC CXX RANLIB STRIP
	# qmake-generated Makefiles use LD/LINK for linking
	export LD="$(tc-getCXX)"

	pushd "${QT5_BUILD_DIR}" > /dev/null || die

	if [[ ${EGIT_PROJECT} == "qtbase" ]]; then
		qt5_base_configure
	fi

	einfo "Running qmake"
	./bin/qmake -recursive \
		"${S}"/${EGIT_PROJECT}.pro \
		$(version_is_at_least 5.0.0_beta2 || echo "CONFIG+=nostrip") \
		QMAKE_LIBDIR+="${QT5_BUILD_DIR}/lib" \
		QMAKE_LIBDIR+="${QTLIBDIR}" \
		|| die "qmake failed"

	popd > /dev/null || die
}

# @FUNCTION: qt5-build_src_compile
# @DESCRIPTION:
# Compiles the code in target directories.
qt5-build_src_compile() {
	qt5_foreach_target_subdir emake
}

# @FUNCTION: qt5-build_src_test
# @DESCRIPTION:
# Runs tests in target directories.
# TODO: find a way to avoid circular deps with USE=test.
qt5-build_src_test() {
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
		"${QT5_BUILD_DIR}"/bin/qmake \
			"${S}/${subdir}/${subdir##*/}.pro" \
			|| die "qmake failed"
	}
	qt5_foreach_target_subdir qmake
	qt5_foreach_target_subdir emake
	qt5_foreach_target_subdir emake TESTRUNNER="'${testrunner}'" check
}

# @FUNCTION: qt5-build_src_install
# @DESCRIPTION:
# Performs the actual installation of target directories.
# TODO: pkgconfig files are installed in the wrong place
qt5-build_src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install

	if [[ ${PN} == "qt-core" ]]; then
		pushd "${QT5_BUILD_DIR}" > /dev/null || die
		emake INSTALL_ROOT="${D}" install_{mkspecs,qmake,syncqt}
		popd > /dev/null || die

		# create an empty Gentoo/gentoo-qconfig.h
		dodir "${QTHEADERDIR#${EPREFIX}}"/Gentoo
		: > "${D}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h

		# include gentoo-qconfig.h at the beginning of Qt{,Core}/qconfig.h
		sed -i -e '2a#include <Gentoo/gentoo-qconfig.h>\n' \
			"${D}${QTHEADERDIR}"/QtCore/qconfig.h \
			"${D}${QTHEADERDIR}"/Qt/qconfig.h \
			|| die "sed qconfig.h failed"
	fi

	qt5_install_module_qconfigs

	# remove .la files since we are building only shared libraries
	prune_libtool_files
}

# @FUNCTION: qt5-build_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration, plus throw a message about possible
# breakages and proposed solutions.
qt5-build_pkg_postinst() {
	qt5_regenerate_global_qconfigs
}

# @FUNCTION: qt5-build_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when the package is completely removed.
qt5-build_pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${PN} != "qt-core" ]]; then
		qt5_regenerate_global_qconfigs
	fi
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

# @FUNCTION: qt5_symlink_tools_to_buildtree
# @INTERNAL
# @DESCRIPTION:
# Symlinks qt-core tools to buildtree, so they can be used when building other modules.
qt5_symlink_tools_to_buildtree() {
	mkdir -p "${QT5_BUILD_DIR}"/bin || die

	local bin
	for bin in "${QTBINDIR}"/{qmake,moc,rcc,uic,qdoc,qdbuscpp2xml,qdbusxml2cpp}; do
		if [[ -e ${bin} ]]; then
			ln -s "${bin}" "${QT5_BUILD_DIR}"/bin/ || die "failed to symlink ${bin}"
		fi
	done
}

# @FUNCTION: qt5_base_configure
# @INTERNAL
# @DESCRIPTION:
# Runs ./configure for modules belonging to qtbase.
qt5_base_configure() {
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
		-shared
		-dont-process
		-pkg-config

		# prefer system libraries
		-system-zlib
		-system-pcre

		# exclude examples and tests from default build
		-nomake examples
		-nomake tests

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(use prefix || echo -no-rpath)

		# verbosity of the configure and build phases
		-verbose $(${QT5_VERBOSE_BUILD} || echo -silent)

		# don't strip
		$(version_is_at_least 5.0.0_beta2 && echo -no-strip)

		# precompiled headers don't work on hardened, where the flag is masked
		$(qt_use pch)

		# reduce relocations in libraries through extra linker optimizations
		# requires GNU ld >= 2.18
		-reduce-relocations

		# disable all SQL drivers by default, override in qt-sql
		-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc
		-no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -no-sql-tds

		# disable all platform plugins by default, override in qt-gui
		-no-xcb -no-xrender -no-eglfs -no-directfb -no-linuxfb -no-kms

		# disable gtkstyle because it adds qt4 include paths to the compiler
		# command line if x11-libs/cairo is built with USE=qt4 (bug 433826)
		# TODO: fix properly in qt-widgets
		-no-gtkstyle

		# module-specific options
		"${myconf[@]}"
	)

	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"
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

# @FUNCTION: qt5_install_module_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Creates and installs gentoo-specific ${PN}-qconfig.{h,pri} files.
qt5_install_module_qconfigs() {
	local x

	# qconfig.h
	: > "${T}"/${PN}-qconfig.h
	for x in ${QCONFIG_DEFINE}; do
		echo "#define ${x}" >> "${T}"/${PN}-qconfig.h
	done
	[[ -s ${T}/${PN}-qconfig.h ]] && (
		insinto "${QTHEADERDIR#${EPREFIX}}"/Gentoo
		doins "${T}"/${PN}-qconfig.h
	)

	# qconfig.pri
	: > "${T}"/${PN}-qconfig.pri
	for x in QCONFIG_ADD QCONFIG_REMOVE; do
		[[ -n ${!x} ]] && echo "${x}=${!x}" >> "${T}"/${PN}-qconfig.pri
	done
	[[ -s ${T}/${PN}-qconfig.pri ]] && (
		insinto "${QTDATADIR#${EPREFIX}}"/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri
	)
}

# @FUNCTION: qt5_regenerate_global_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Generates gentoo-specific qconfig.{h,pri}.
# Don't die here because dying in pkg_post{inst,rm} just makes things worse.
qt5_regenerate_global_qconfigs() {
	einfo "Regenerating gentoo-qconfig.h"

	find "${ROOT}${QTHEADERDIR}"/Gentoo -name 'qt-*-qconfig.h' -type f \
		-exec cat {} + > "${T}"/gentoo-qconfig.h

	[[ -s ${T}/gentoo-qconfig.h ]] || ewarn "Generated gentoo-qconfig.h is empty"
	mv -f "${T}"/gentoo-qconfig.h "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h \
		|| eerror "Failed to install new gentoo-qconfig.h"

	einfo "Updating QT_CONFIG in qconfig.pri"

	local qconfig_pri=${ROOT}${QTDATADIR}/mkspecs/qconfig.pri
	if [[ -f ${qconfig_pri} ]]; then
		local x qconfig_add= qconfig_remove=
		local qt_config=$(sed -n 's/^QT_CONFIG +=//p' "${qconfig_pri}")
		local new_qt_config=

		# generate list of QT_CONFIG entries from the existing list,
		# appending QCONFIG_ADD and excluding QCONFIG_REMOVE
		eshopts_push -s nullglob
		for x in "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qt-*-qconfig.pri; do
			qconfig_add+=" $(sed -n 's/^QCONFIG_ADD=//p' "${x}")"
			qconfig_remove+=" $(sed -n 's/^QCONFIG_REMOVE=//p' "${x}")"
		done
		eshopts_pop
		for x in ${qt_config} ${qconfig_add}; do
			if ! has "${x}" ${new_qt_config} ${qconfig_remove}; then
				new_qt_config+=" ${x}"
			fi
		done

		# now replace the existing QT_CONFIG with the generated list
		sed -i -e "s/^QT_CONFIG +=.*/QT_CONFIG +=${new_qt_config}/" \
			"${qconfig_pri}" || eerror "Failed to sed QT_CONFIG in qconfig.pri"
	else
		ewarn "'${qconfig_pri}' does not exist or is not a regular file"
	fi
}
