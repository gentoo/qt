# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt4-build-edge.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @BLURB: Eclass for Qt4 split ebuilds in qting-edge overlay.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt4

# WARNING: This eclass requires EAPI=2 or EAPI=3
#
# NOTES:
#
#	4.9999 and 4.?.9999[-kde-qt]
#			stands for live ebuilds from qtsoftware's git repository
#			(that is Nokia, previously trolltech)
#	4.?.9999[kde-qt]
#			stands for live ebuilds from kde-qt git repository
#	4.*.*_{beta,rc,}* and *
#			are official releases or snapshots from Nokia
#

MY_EGIT_COMMIT=${EGIT_COMMIT:=}

inherit git qt4-build

[[ ${PV} == *.9999 ]] && SRC_URI=

case "${PV}" in
	4.9999 | 4.7.9999)
		IUSE+=" +stable-branch"
		;;
	4.6.9999)
		IUSE+=" stable-branch +kde-qt"
		;;
esac

[[ ${PV} == *.9999 ]] && DEPEND="dev-lang/perl"

# @FUNCTION: qt4-build-edge_pkg_setup
# @DESCRIPTION:
# Sets up PATH, {,DY}LD_LIBRARY_PATH and EGIT_* variables.
qt4-build-edge_pkg_setup() {
	debug-print-function $FUNCNAME "$@"

	case "${PV}" in
		4.9999 | 4.7.9999)
			if use stable-branch; then
				MY_PV_EXTRA="${PV}-stable"
			else
				MY_PV_EXTRA="${PV}"
			fi
			;;
		4.6.9999)
			if use kde-qt; then
				if use stable-branch; then
					MY_PV_EXTRA="${PV}-kde-qt-stable"
				else
					MY_PV_EXTRA="${PV}-kde-qt"
				fi
			else
				if use stable-branch; then
					MY_PV_EXTRA="${PV}-stable"
				else
					MY_PV_EXTRA="${PV}"
				fi
			fi
			;;
		*)
			MY_PV_EXTRA="${PV}"
			;;
	esac

	case "${MY_PV_EXTRA}" in
		4.6.9999-kde-qt-stable)
			EGIT_REPO_URI="git://gitorious.org/+kde-developers/qt/kde-qt.git"
			EGIT_PROJECT="qt-${PV}"
			EGIT_BRANCH="4.6-stable-patched"
			;;
		4.6.9999-kde-qt)
			EGIT_REPO_URI="git://gitorious.org/+kde-developers/qt/kde-qt.git"
			EGIT_PROJECT="qt-${PV}"
			EGIT_BRANCH="master"
			;;
		4.?.9999 | 4.?.9999-stable)
			EGIT_REPO_URI="git://gitorious.org/qt/qt.git"
			EGIT_PROJECT="qt-${PV}"
			EGIT_BRANCH="${MY_PV_EXTRA/.9999}"
			;;
		4.9999-stable)
			EGIT_REPO_URI="git://gitorious.org/qt/qt.git"
			EGIT_PROJECT="qt-${PV}"
			EGIT_BRANCH="master-stable"
			;;
		4.9999)
			EGIT_REPO_URI="git://gitorious.org/qt/qt.git"
			EGIT_PROJECT="qt-${PV}"
			EGIT_BRANCH="master"
			;;
	esac

	EGIT_COMMIT=${MY_EGIT_COMMIT:=${EGIT_BRANCH}}

	# Let users know what they are getting themselves into ;-)
	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		ewarn
		ewarn "Please file bugs on bugs.gentoo.org and prepend the summary"
		ewarn "with [qting-edge]. Alternatively, contact <qt@gentoo.org>."
		ewarn "Thank you for using qting-edge overlay."
		ewarn
		case "${MY_PV_EXTRA}" in
			4.?.9999-kde-qt)
				ewarn "The ${PV} version ebuilds with kde-qt USE flag install kde-qt from gitorious kde-qt repository."
				;;
			4.?.9999-kde-qt-stable)
				ewarn "The ${PV} version ebuilds with kde-qt and stable-branch USE flags install kde-qt from"
				ewarn "gitorious kde-qt repository, '4.6-stable-patched' branch."
				;;
			4.?.9999-stable | 4.9999-stable)
				ewarn "The ${PV} version ebuilds install live git code from Nokia Qt Software - stable branch."
				ewarn "See http://labs.trolltech.com/blogs/2009/07/28/getting-the-best-out-of-two-worlds/"
				;;
			4.?.9999 | 4.9999)
				ewarn "The ${PV} version ebuilds install live git code from Nokia Qt Software."
				;;
			4.6.0_alpha_pre*)
				ewarn "The ${PV} version ebuilds install a technical preview from Nokia Qt Software."
				ewarn "See http://labs.trolltech.com/blogs/2009/09/09/qt-460-tech-preview-1/"
				;;
			4.*.*_*)
				ewarn "The ${PV} version ebuilds install a pre-release from Nokia Qt Software."
				;;
		esac
		ewarn
	fi
	# stable-branch is outdated.Last commit on 4th of April. Adding warning
	# wrt bug #313619
	if use stable-branch && version_is_at_least "4.7.9999"; then
		ewarn
		ewarn				"!!! WARNING !!!"
		ewarn "Qt-${PV/.9999} stable branch is outdated. If you are"
		ewarn "seeking for bleeding edge code your are kindly advised"
		ewarn "to disable 'stable-branch' use flag and rebuild all the Qt modules"
		ewarn
	fi
	qt4-build_pkg_setup
}

# @ECLASS-VARIABLE: QT4_TARGET_DIRECTORIES
# @DESCRIPTION:
# Arguments for build_target_directories. Takes the directories in which the
# code should be compiled. This is a space-separated list of relative paths.

# @ECLASS-VARIABLE: QT4_EXTRACT_DIRECTORIES
# @DESCRIPTION:
# Space-separated list of directories that will be extracted from Qt tarball.

# @FUNCTION: qt4-build-edge_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt4-build-edge_src_unpack() {
	debug-print-function $FUNCNAME "$@"
	setqtenv

	local target= targets=
	for target in configure LICENSE.{GPL3,LGPL} projects.pro \
			src/{qbase,qt_targets,qt_install}.pri \
			bin config.tests mkspecs qmake \
			${QT4_EXTRACT_DIRECTORIES}; do
		targets+=" ${MY_P}/${target}"
	done

	case "${PV}" in
		*.9999)
			git_src_unpack
			;;
		*)
			echo tar xzf "${DISTDIR}"/${MY_P}.tar.gz ${targets}
			tar xzf "${DISTDIR}"/${MY_P}.tar.gz ${targets} || die
			;;
	esac
}

# @ECLASS-VARIABLE: PATCHES
# @DESCRIPTION:
# In case you have patches to apply, specify them here. Make sure to specify
# the full path. This variable is necessary for src_prepare phase.
# Example:
# PATCHES=( "${FILESDIR}"/mypatch.patch
# "${FILESDIR}"/mypatch2.patch )

# @FUNCTION: qt4-build-edge_src_prepare
# @DESCRIPTION:
# Prepares the sources before the configure phase. Strips C(XX)FLAGS if necessary, and fixes
# source files in order to respect CFLAGS/CXXFLAGS/LDFLAGS specified on /etc/make.conf.
qt4-build-edge_src_prepare() {
	debug-print-function $FUNCNAME "$@"
	local NOLIBX11PKG="qt-core qt-dbus qt-script qt-sql qt-test qt-xmlpatterns"

	hasq ${PN} ${NOLIBX11PKG} && qt_nolibx11

	if [[ ${PV} == *.9999 ]]; then
		[[ ${PN} == qt-assistant ]] && qt_assistant_cleanup
		generate_include
	fi

	# We need to remove any specific hardcoded compiler flags
	sed -i -e '/^QMAKE_CFLAGS[^_.*]/s:\+=.*:=:' \
		-e '/^QMAKE_CXXFLAGS[^_.*]/s:\+=.*:=:' \
		-e '/^QMAKE_LFLAGS[^_.*]/s:\+=.*:=:' \
		"${S}"/mkspecs/common/g++.conf

	qt4-build_src_prepare
}

# @FUNCTION: qt4-build-edge_src_configure
# @DESCRIPTION:
# Runs ./configure with appropriate arguments. You can use
# the ${myconf} variable to pass additional arguments.
qt4-build-edge_src_configure() {
	debug-print-function $FUNCNAME "$@"
	qt4-build_src_configure
}

# @FUNCTION: qt4-build-edge_src_compile
# @DESCRIPTION:
# Compiles the code in ${QT4_TARGET_DIRECTORIES}.
qt4-build-edge_src_compile() {
	debug-print-function $FUNCNAME "$@"
	qt4-build_src_compile
}

# @FUNCTION: qt4-build-edge_src_install
# @DESCRIPTION:
# Performs the actual installation including some library fixes.
qt4-build-edge_src_install() {
	debug-print-function $FUNCNAME "$@"
	qt4-build_src_install
}

# @FUNCTION: qt4-build-edge_pkg_postrm
# @DESCRIPTION:
# Generates configuration when the package is completely removed.
qt4-build-edge_pkg_postrm() {
	debug-print-function $FUNCNAME "$@"
	qt4-build_pkg_postrm
}

# @FUNCTION: qt4-build-edge_pkg_postinst
# @DESCRIPTION:
# Generates configuration after the package is installed.
qt4-build-edge_pkg_postinst() {
	debug-print-function $FUNCNAME "$@"
	qt4-build_pkg_postinst
}

# @FUNCTION: generate_include
# @DESCRIPTION:
# Internal function, required for live ebuilds.
generate_include() {
	QTDIR="." perl bin/syncqt
}

# @FUNCTION: qt_assistant_cleanup
# @RETURN: nothing
# @DESCRIPTION:
# Tries to clean up tools.pro for live qt-assistant ebuilds
# Meant to be called in src_prepare
qt_assistant_cleanup() {
	# different versions (and branches...) may need different handling,
	# add a case if you need special handling
	case "${MY_PV_EXTRA}" in
		*kde-qt*)
			sed -e "/^[ \t]*porting/,/^[ \t]*win32.*activeqt$/d" \
				-e "/mac/,/^embedded.*makeqpf$/d" \
				-i tools/tools.pro || die "patching tools.pro failed"
		;;
		*)
			sed -e "/^[ \t]*porting/,/^[ \t]*win32.*activeqt$/d" \
				-e "/mac/,/^embedded.*makeqpf$/d" \
				-e "s/^\([ \t]*pixeltool\) /\1 qdoc3 /" \
				-i tools/tools.pro || die "patching tools.pro failed"
		;;
	esac
}

qt_nolibx11() {
	# delete any referense to X libraries for packages that dont use it
	einfo "removing X11 check to allow X-less compilation"
	sed -i "/unixtests\/compile.test.*config.tests\/x11\/xlib/,/fi$/d" "${S}"/configure ||
		die "x11 check sed failed"
}
EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postrm pkg_postinst
