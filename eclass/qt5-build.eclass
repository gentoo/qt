# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt5-build.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.
# Requires EAPI 5.

case ${EAPI} in
	5)	: ;;
	*)	die "qt5-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit eutils flag-o-matic multilib toolchain-funcs virtualx

HOMEPAGE="http://qt-project.org/ http://qt.digia.com/"
LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="5"

# @ECLASS-VARIABLE: QT5_MODULE
# @DESCRIPTION:
# The upstream name of the module this package belongs to. Used for
# SRC_URI and EGIT_REPO_URI. Must be defined before inheriting the eclass.
: ${QT5_MODULE:=${PN}}

case ${PV} in
	5.9999)
		# git dev branch
		QT5_BUILD_TYPE="live"
		EGIT_BRANCH="dev"
		;;
	5.?.9999)
		# git stable branches (5.x)
		QT5_BUILD_TYPE="live"
		EGIT_BRANCH=${PV%.9999}
		;;
	*_alpha*|*_beta*|*_rc*)
		# development releases
		QT5_BUILD_TYPE="release"
		MY_P=${QT5_MODULE}-opensource-src-${PV/_/-}
		SRC_URI="http://download.qt-project.org/development_releases/qt/${PV%.*}/${PV/_/-}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
	*)
		# official stable releases
		QT5_BUILD_TYPE="release"
		MY_P=${QT5_MODULE}-opensource-src-${PV}
		SRC_URI="http://download.qt-project.org/official_releases/qt/${PV%.*}/${PV}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
esac

EGIT_REPO_URI=(
	"git://gitorious.org/qt/${QT5_MODULE}.git"
	"https://git.gitorious.org/qt/${QT5_MODULE}.git"
)
[[ ${QT5_BUILD_TYPE} == live ]] && inherit git-r3

IUSE="debug test"

DEPEND="
	dev-lang/perl
	virtual/pkgconfig
"
if [[ ${PN} != qttest ]]; then
	if [[ ${QT5_MODULE} == qtbase ]]; then
		DEPEND+=" test? ( ~dev-qt/qttest-${PV}[debug=] )"
	else
		DEPEND+=" test? ( >=dev-qt/qttest-${PV}:5[debug=] )"
	fi
fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install src_test pkg_postinst pkg_postrm

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
case ${QT5_BUILD_TYPE} in
	live)    : ${QT5_BUILD_DIR:=${S}_build} ;;
	release) : ${QT5_BUILD_DIR:=${S}} ;; # workaround for bug 497312
esac

# @ECLASS-VARIABLE: QT5_GENTOO_CONFIG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <useflag:feature:macro> triplets that are evaluated in src_install
# to generate the per-package list of enabled QT_CONFIG features and macro
# definitions, which are then merged together with all other Qt5 packages
# installed on the system to obtain the global qconfig.{h,pri} files.

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass man page.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

# @FUNCTION: qt5-build_pkg_setup
# @DESCRIPTION:
# Warns and/or dies if the user is trying to downgrade Qt.
qt5-build_pkg_setup() {
	# Warn users of possible breakage when downgrading to a previous release.
	# Downgrading revisions within the same release is safe.
	if has_version ">${CATEGORY}/${P}-r9999:5"; then
		ewarn
		ewarn "Downgrading Qt is completely unsupported and can break your system!"
		ewarn
	fi
}

# @FUNCTION: qt5-build_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt5-build_src_unpack() {
	if [[ $(gcc-major-version) -lt 4 ]] || [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 5 ]]; then
		ewarn
		ewarn "Using a GCC version lower than 4.5 is not supported."
		ewarn
	fi

	if [[ ${PN} == qtwebkit ]]; then
		eshopts_push -s extglob
		if is-flagq '-g?(gdb)?([1-9])'; then
			ewarn
			ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
			ewarn "You may experience really long compilation times and/or increased memory usage."
			ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
			ewarn "For more info check out https://bugs.gentoo.org/307861"
			ewarn
		fi
		eshopts_pop
	fi

	case ${QT5_BUILD_TYPE} in
		live)    git-r3_src_unpack ;;
		release) default ;;
	esac
}

# @FUNCTION: qt5-build_src_prepare
# @DESCRIPTION:
# Prepares the sources before the configure phase.
qt5-build_src_prepare() {
	qt5_prepare_env

	if [[ ${QT5_MODULE} == qtbase ]]; then
		# Avoid unnecessary qmake recompilations
		sed -i -re "s|^if true;.*(\[ '\!').*(\"\\\$outpath/bin/qmake\".*)|if \1 -e \2 then|" \
			configure || die "sed failed (skip qmake bootstrap)"

		# Respect CC, CXX, *FLAGS, MAKEOPTS and EXTRA_EMAKE when bootstrapping qmake
		sed -i -e "/outpath\/qmake\".*\"\$MAKE\")/ s:): \
			${MAKEOPTS} ${EXTRA_EMAKE} 'CC=$(tc-getCC)' 'CXX=$(tc-getCXX)' \
			'QMAKE_CFLAGS=${CFLAGS}' 'QMAKE_CXXFLAGS=${CXXFLAGS}' 'QMAKE_LFLAGS=${LDFLAGS}'&:" \
			-e '/"$CFG_RELEASE_QMAKE"/,/^\s\+fi$/ d' \
			configure || die "sed failed (respect env for qmake build)"
		sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
			qmake/Makefile.unix || die "sed failed (CPPFLAGS for qmake build)"

		# Respect CXX in configure
		sed -i -e "/^QMAKE_CONF_COMPILER=/ s:=.*:=\"$(tc-getCXX)\":" \
			configure || die "sed failed (QMAKE_CONF_COMPILER)"

		# Respect toolchain and flags in config.tests
		find config.tests/unix -name '*.test' -type f -print0 | xargs -0 \
			sed -ri -e '/CXXFLAGS=/ s/"(\$CXXFLAGS) (\$PARAM)"/"\2 \1"/' \
				-e '/LFLAGS=/ s/"(\$LFLAGS) (\$PARAM)"/"\2 \1"/' \
				-e '/bin\/qmake/ s/-nocache //' \
			|| die "sed failed (config.tests)"
	fi

	if [[ ${PN} != qtcore ]]; then
		qt5_symlink_tools_to_build_dir
	fi

	# apply patches
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user
}

# @FUNCTION: qt5-build_src_configure
# @DESCRIPTION:
# Runs qmake, possibly preceded by ./configure.
qt5-build_src_configure() {
	mkdir -p "${QT5_BUILD_DIR}" || die
	pushd "${QT5_BUILD_DIR}" >/dev/null || die

	if [[ ${QT5_MODULE} == qtbase ]]; then
		# toolchain setup
		tc-export CC CXX RANLIB STRIP
		export LD="$(tc-getCXX)"

		qt5_base_configure
	fi

	qt5_foreach_target_subdir qt5_qmake

	popd >/dev/null || die
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
qt5-build_src_test() {
	echo ">>> Test phase [QtTest]: ${CATEGORY}/${PF}"

	# create a custom testrunner script that correctly sets
	# {,DY}LD_LIBRARY_PATH before executing the given test
	local testrunner=${QT5_BUILD_DIR}/gentoo-testrunner
	cat <<-EOF > "${testrunner}"
	#!/bin/sh
	export LD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QT5_LIBDIR}"
	export DYLD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QT5_LIBDIR}"
	"\$@"
	EOF
	chmod +x "${testrunner}"

	# '-after SUBDIRS-=cmake' disables broken tests - bug #474004
	qt5_foreach_target_subdir qt5_qmake -after SUBDIRS-=cmake
	qt5_foreach_target_subdir emake

	_test_runner() {
		qt5_foreach_target_subdir emake TESTRUNNER="'${testrunner}'" check
	}

	if [[ ${VIRTUALX_REQUIRED} == test ]]; then
		VIRTUALX_COMMAND="_test_runner" virtualmake
	else
		_test_runner
	fi
}

# @FUNCTION: qt5-build_src_install
# @DESCRIPTION:
# Performs the actual installation of target directories.
qt5-build_src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install

	if [[ ${PN} == qtcore ]]; then
		pushd "${QT5_BUILD_DIR}" >/dev/null || die
		einfo "Running emake INSTALL_ROOT=${D} install_{mkspecs,qmake,syncqt}"
		emake INSTALL_ROOT="${D}" install_{mkspecs,qmake,syncqt}
		popd >/dev/null || die

		# install an empty Gentoo/gentoo-qconfig.h in ${D}
		# so that it's placed under package manager control
		> "${T}"/gentoo-qconfig.h
		(
			insinto "${QT5_HEADERDIR#${EPREFIX}}"/Gentoo
			doins "${T}"/gentoo-qconfig.h
		)

		# include gentoo-qconfig.h at the beginning of QtCore/qconfig.h
		sed -i -e '1a#include <Gentoo/gentoo-qconfig.h>\n' \
			"${D}${QT5_HEADERDIR}"/QtCore/qconfig.h \
			|| die "sed failed (qconfig.h)"
	fi

	qt5_install_module_qconfigs
	prune_libtool_files
}

# @FUNCTION: qt5-build_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration after installation or upgrade/downgrade.
qt5-build_pkg_postinst() {
	qt5_regenerate_global_qconfigs
}

# @FUNCTION: qt5-build_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when a module is completely removed.
qt5-build_pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${PN} != qtcore ]]; then
		qt5_regenerate_global_qconfigs
	fi
}

# @FUNCTION: qt_use
# @USAGE: <flag> [feature] [enableopt]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
#
# Echoes "-${enableopt}-${feature}" if <flag> is enabled, or "-no-${feature}"
# if it is disabled. If [feature] is not specified, it defaults to the value
# of <flag>. If [enableopt] is not specified, the whole "-${enableopt}" prefix
# is omitted.
qt_use() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	use "$1" && echo "${3:+-$3}-${2:-$1}" || echo "-no-${2:-$1}"
}

# @FUNCTION: qt_use_compile_test
# @USAGE: <flag> [config]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# [config] is the argument of qtCompileTest, defaults to <flag>.
#
# This function is useful to disable optional dependencies that are checked
# at qmake-time using the qtCompileTest() function. If <flag> is disabled,
# the compile test is skipped and the dependency is assumed to be unavailable,
# i.e. the corresponding feature will be disabled. Note that all invocations
# of this function must happen before calling qt5-build_src_configure.
qt_use_compile_test() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	if ! use "$1"; then
		mkdir -p "${QT5_BUILD_DIR}" || die
		echo "CONFIG += done_config_${2:-$1}" >> "${QT5_BUILD_DIR}"/.qmake.cache || die
	fi
}

# @FUNCTION: qt_use_disable_mod
# @USAGE: <flag> <module> <files...>
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <module> is the (lowercase) name of a Qt5 module.
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to treat <module> as not installed
# when <flag> is disabled, otherwise it does nothing.
# This can be useful to avoid an automagic dependency when the module
# is present on the system but the corresponding USE flag is disabled.
qt_use_disable_mod() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least three arguments"

	local flag=$1
	local module=$2
	shift 2

	if ! use "${flag}"; then
		echo "$@" | xargs sed -i -e "s/qtHaveModule(${module})/false/g" || die
	fi
}


######  Internal functions  ######

# @FUNCTION: qt5_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt5_prepare_env() {
	# setup installation directories
	QT5_PREFIX=${EPREFIX}/usr
	QT5_HEADERDIR=${QT5_PREFIX}/include/qt5
	QT5_LIBDIR=${QT5_PREFIX}/$(get_libdir)
	QT5_ARCHDATADIR=${QT5_PREFIX}/$(get_libdir)/qt5
	QT5_BINDIR=${QT5_ARCHDATADIR}/bin
	QT5_PLUGINDIR=${QT5_ARCHDATADIR}/plugins
	QT5_LIBEXECDIR=${QT5_ARCHDATADIR}/libexec
	QT5_IMPORTDIR=${QT5_ARCHDATADIR}/imports
	QT5_QMLDIR=${QT5_ARCHDATADIR}/qml
	QT5_DATADIR=${QT5_PREFIX}/share/qt5
	QT5_DOCDIR=${QT5_PREFIX}/share/doc/qt-${PV}
	QT5_TRANSLATIONDIR=${QT5_DATADIR}/translations
	QT5_EXAMPLESDIR=${QT5_DATADIR}/examples
	QT5_TESTSDIR=${QT5_DATADIR}/tests
	QT5_SYSCONFDIR=${EPREFIX}/etc/xdg

	if [[ ${QT5_MODULE} == qtbase ]]; then
		# see mkspecs/features/qt_config.prf
		export QMAKEMODULES="${QT5_BUILD_DIR}/mkspecs/modules:${S}/mkspecs/modules:${QT5_ARCHDATADIR}/mkspecs/modules"
	fi
}

# @FUNCTION: qt5_foreach_target_subdir
# @INTERNAL
# @DESCRIPTION:
# Executes the arguments inside each directory listed in QT5_TARGET_SUBDIRS.
qt5_foreach_target_subdir() {
	[[ -z ${QT5_TARGET_SUBDIRS[@]} ]] && QT5_TARGET_SUBDIRS=("")

	local ret=0 subdir=
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		if [[ ${EBUILD_PHASE} == test ]]; then
			subdir=tests/auto${subdir#src}
			[[ -d ${S}/${subdir} ]] || continue
		fi

		mkdir -p "${QT5_BUILD_DIR}/${subdir}" || die
		pushd "${QT5_BUILD_DIR}/${subdir}" >/dev/null || die

		einfo "Running $* ${subdir:+in ${subdir}}"
		"$@"
		((ret+=$?))

		popd >/dev/null || die
	done

	return ${ret}
}

# @FUNCTION: qt5_symlink_tools_to_build_dir
# @INTERNAL
# @DESCRIPTION:
# Symlinks qtcore tools to QT5_BUILD_DIR, so they can be used when building other modules.
qt5_symlink_tools_to_build_dir() {
	mkdir -p "${QT5_BUILD_DIR}"/bin || die

	local bin
	for bin in "${QT5_BINDIR}"/{qmake,moc,rcc,uic,qdoc,qdbuscpp2xml,qdbusxml2cpp}; do
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
		-prefix "${QT5_PREFIX}"
		-bindir "${QT5_BINDIR}"
		-headerdir "${QT5_HEADERDIR}"
		-libdir "${QT5_LIBDIR}"
		-archdatadir "${QT5_ARCHDATADIR}"
		-plugindir "${QT5_PLUGINDIR}"
		-libexecdir "${QT5_LIBEXECDIR}"
		-importdir "${QT5_IMPORTDIR}"
		-qmldir "${QT5_QMLDIR}"
		-datadir "${QT5_DATADIR}"
		-docdir "${QT5_DOCDIR}"
		-translationdir "${QT5_TRANSLATIONDIR}"
		-sysconfdir "${QT5_SYSCONFDIR}"
		-examplesdir "${QT5_EXAMPLESDIR}"
		-testsdir "${QT5_TESTSDIR}"

		# debug/release
		$(use debug && echo -debug || echo -release)
		-no-separate-debug-info

		# licensing stuff
		-opensource -confirm-license

		# let configure automatically figure out if C++11 is supported
		#-c++11

		# build shared libraries
		-shared

		# always enable large file support
		-largefile

		# disabling accessibility is not recommended by upstream, as
		# it will break QStyle and may break other internal parts of Qt
		-accessibility

		# disable all SQL drivers by default, override in qtsql
		-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc
		-no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -no-sql-tds

		# obsolete flag, does nothing
		#-qml-debug

		# use pkg-config to detect include and library paths
		-pkg-config

		# prefer system libraries (only common deps here)
		-system-zlib
		-system-pcre

		# don't specify -no-gif because there is no way to override it later
		#-no-gif

		# disable everything to prevent automagic deps (part 1)
		-no-mtdev
		-no-journald
		-no-libpng -no-libjpeg
		-no-freetype -no-harfbuzz
		-no-openssl
		-no-xinput2 -no-xcb-xlib

		# always enable glib event loop support
		-glib

		# disable everything to prevent automagic deps (part 2)
		-no-pulseaudio -no-alsa

		# disable gtkstyle because it adds qt4 include paths to the compiler
		# command line if x11-libs/cairo is built with USE=qt4 (bug 433826)
		-no-gtkstyle

		# exclude examples and tests from default build
		-nomake examples
		-nomake tests
		-no-compile-examples

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(use prefix || echo -no-rpath)

		# print verbose information about each configure test
		-verbose

		# doesn't actually matter since we override CXXFLAGS
		#-no-optimized-qmake

		# obsolete flag, does nothing
		#-nis

		# always enable iconv support
		-iconv

		# disable everything to prevent automagic deps (part 3)
		-no-cups -no-evdev -no-icu -no-fontconfig -no-dbus

		# don't strip
		-no-strip

		# precompiled headers are not that useful for us
		# and cause problems on hardened, so turn them off
		-no-pch

		# reduced relocations cause major breakage on at least arm and ppc, so we
		# don't specify anything and let configure figure out if they are supported,
		# see also https://bugreports.qt-project.org/browse/QTBUG-36129
		#-reduce-relocations

		# let configure automatically detect if GNU gold is available
		#-use-gold-linker

		# disable all platform plugins by default, override in qtgui
		-no-xcb -no-eglfs -no-directfb -no-linuxfb -no-kms

		# disable undocumented X11-related flags, override in qtgui
		# (not shown in ./configure -help output)
		-no-xkb -no-xrender

		# disable obsolete/unused X11-related flags
		# (not shown in ./configure -help output)
		-no-mitshm -no-xcursor -no-xfixes -no-xinerama -no-xinput
		-no-xrandr -no-xshape -no-xsync -no-xvideo

		# always enable session management support: it doesn't need extra deps
		# at configure time and turning it off is dangerous, see bug 518262
		-sm

		# typedef qreal to double (warning: changing this flag breaks the ABI)
		-qreal double

		# disable opengl and egl by default, override in qtgui and qtopengl
		-no-opengl -no-egl

		# use upstream default
		#-no-system-proxies

		# do not build with -Werror
		-no-warnings-are-errors

		# module-specific options
		"${myconf[@]}"
	)

	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"
}

# @FUNCTION: qt5_qmake
# @INTERNAL
# @DESCRIPTION:
# Helper function that runs qmake in the current target subdir.
# Intended to be called by qt5_foreach_target_subdir().
qt5_qmake() {
	local projectdir=${PWD/#${QT5_BUILD_DIR}/${S}}

	"${QT5_BUILD_DIR}"/bin/qmake \
		QMAKE_AR="$(tc-getAR) cqs" \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_LINK_C="$(tc-getCC)" \
		QMAKE_LINK_C_SHLIB="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_LINK_SHLIB="$(tc-getCXX)" \
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
		QMAKE_RANLIB= \
		QMAKE_STRIP="$(tc-getSTRIP)" \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		"${projectdir}" \
		"$@" \
		|| die "qmake failed (${projectdir})"
}

# @FUNCTION: qt5_install_module_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Creates and installs gentoo-specific ${PN}-qconfig.{h,pri} files.
qt5_install_module_qconfigs() {
	local x qconfig_add= qconfig_remove=

	> "${T}"/${PN}-qconfig.h
	> "${T}"/${PN}-qconfig.pri

	# generate qconfig_{add,remove} and ${PN}-qconfig.h
	for x in "${QT5_GENTOO_CONFIG[@]}"; do
		local flag=${x%%:*}
		x=${x#${flag}:}
		local feature=${x%%:*}
		x=${x#${feature}:}
		local macro=${x}
		macro=$(tr 'a-z-' 'A-Z_' <<< "${macro}")

		if [[ -z ${flag} ]] || { [[ ${flag} != '!' ]] && use ${flag}; }; then
			[[ -n ${feature} ]] && qconfig_add+=" ${feature}"
			[[ -n ${macro} ]] && echo "#define QT_${macro}" >> "${T}"/${PN}-qconfig.h
		else
			[[ -n ${feature} ]] && qconfig_remove+=" ${feature}"
			[[ -n ${macro} ]] && echo "#define QT_NO_${macro}" >> "${T}"/${PN}-qconfig.h
		fi
	done

	# install ${PN}-qconfig.h
	[[ -s ${T}/${PN}-qconfig.h ]] && (
		insinto "${QT5_HEADERDIR#${EPREFIX}}"/Gentoo
		doins "${T}"/${PN}-qconfig.h
	)

	# generate and install ${PN}-qconfig.pri
	[[ -n ${qconfig_add} ]] && echo "QCONFIG_ADD=${qconfig_add}" >> "${T}"/${PN}-qconfig.pri
	[[ -n ${qconfig_remove} ]] && echo "QCONFIG_REMOVE=${qconfig_remove}" >> "${T}"/${PN}-qconfig.pri
	[[ -s ${T}/${PN}-qconfig.pri ]] && (
		insinto "${QT5_ARCHDATADIR#${EPREFIX}}"/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri
	)
}

# @FUNCTION: qt5_regenerate_global_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Generates Gentoo-specific qconfig.{h,pri} according to the build configuration.
# Don't call die here because dying in pkg_post{inst,rm} only makes things worse.
qt5_regenerate_global_qconfigs() {
	einfo "Regenerating gentoo-qconfig.h"

	find "${ROOT%/}${QT5_HEADERDIR}"/Gentoo \
		-name '*-qconfig.h' -a \! -name 'gentoo-qconfig.h' -type f \
		-execdir cat '{}' + | sort -u > "${T}"/gentoo-qconfig.h

	[[ -s ${T}/gentoo-qconfig.h ]] || ewarn "Generated gentoo-qconfig.h is empty"
	mv -f "${T}"/gentoo-qconfig.h "${ROOT%/}${QT5_HEADERDIR}"/Gentoo/gentoo-qconfig.h \
		|| eerror "Failed to install new gentoo-qconfig.h"

	einfo "Updating QT_CONFIG in qconfig.pri"

	local qconfig_pri=${ROOT%/}${QT5_ARCHDATADIR}/mkspecs/qconfig.pri
	if [[ -f ${qconfig_pri} ]]; then
		local x qconfig_add= qconfig_remove=
		local qt_config=$(sed -n 's/^QT_CONFIG\s*+=\s*//p' "${qconfig_pri}")
		local new_qt_config=

		# generate list of QT_CONFIG entries from the existing list,
		# appending QCONFIG_ADD and excluding QCONFIG_REMOVE
		eshopts_push -s nullglob
		for x in "${ROOT%/}${QT5_ARCHDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			qconfig_add+=" $(sed -n 's/^QCONFIG_ADD=\s*//p' "${x}")"
			qconfig_remove+=" $(sed -n 's/^QCONFIG_REMOVE=\s*//p' "${x}")"
		done
		eshopts_pop
		for x in ${qt_config} ${qconfig_add}; do
			if ! has "${x}" ${new_qt_config} ${qconfig_remove}; then
				new_qt_config+=" ${x}"
			fi
		done

		# now replace the existing QT_CONFIG with the generated list
		sed -i -e "s/^QT_CONFIG\s*+=.*/QT_CONFIG +=${new_qt_config}/" \
			"${qconfig_pri}" || eerror "Failed to sed QT_CONFIG in ${qconfig_pri}"
	else
		ewarn "${qconfig_pri} does not exist or is not a regular file"
	fi
}
