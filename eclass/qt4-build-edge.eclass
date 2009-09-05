# Copyright 2007-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt4-build-edge.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>
# Christian Franke <cfchris6@ts2server.com>
# Markos Chandras <hwoarang@gentoo.org>
# Alex Alexander <alex.alexander@gmail.com>
# @BLURB: Eclass for Qt4 split ebuilds in qting-edge overlay.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt4
# Based on the qt4-build eclass by Caleb Tennis <caleb@gentoo.org>

# WARNING: This eclass now requires EAPI=2
#
# NOTES:
#
#	4.9999 and 4.?.9999[-qt-copy]
#			stands for live ebuilds from qtsoftware's git repository
#			(that is Nokia, previously trolltech)
#	4.?.9999[qt-copy]
#			stands for live ebuilds from kde-qt git repository
#	4.*.*_{beta,rc,}* and *
#			are official releases or snapshots from Nokia
#

IUSE="${IUSE} debug pch"
[[ ${CATEGORY}/${PN} != x11-libs/qt-xmlpatterns ]] && IUSE="${IUSE} exceptions"

RDEPEND="
	!<x11-libs/qt-assistant-${PV}
	!>x11-libs/qt-assistant-${PV}-r9999
	!<x11-libs/qt-core-${PV}
	!>x11-libs/qt-core-${PV}-r9999
	!<x11-libs/qt-dbus-${PV}
	!>x11-libs/qt-dbus-${PV}-r9999
	!<x11-libs/qt-demo-${PV}
	!>x11-libs/qt-demo-${PV}-r9999
	!<x11-libs/qt-gui-${PV}
	!>x11-libs/qt-gui-${PV}-r9999
	!<x11-libs/qt-opengl-${PV}
	!>x11-libs/qt-opengl-${PV}-r9999
	!<x11-libs/qt-phonon-${PV}
	!>x11-libs/qt-phonon-${PV}-r9999
	!<x11-libs/qt-qt3support-${PV}
	!>x11-libs/qt-qt3support-${PV}-r9999
	!<x11-libs/qt-script-${PV}
	!>x11-libs/qt-script-${PV}-r9999
	!<x11-libs/qt-sql-${PV}
	!>x11-libs/qt-sql-${PV}-r9999
	!<x11-libs/qt-svg-${PV}
	!>x11-libs/qt-svg-${PV}-r9999
	!<x11-libs/qt-test-${PV}
	!>x11-libs/qt-test-${PV}-r9999
	!<x11-libs/qt-webkit-${PV}
	!>x11-libs/qt-webkit-${PV}-r9999
	!<x11-libs/qt-xmlpatterns-${PV}
	!>x11-libs/qt-xmlpatterns-${PV}-r9999
"

case "${PV}" in
	4.9999)
		IUSE="${IUSE} stable-branch"
		if use stable-branch; then
			MY_PV_QTCOPY="${PV}-stable"
		else
			MY_PV_QTCOPY="${PV}"
		fi
		;;
	4.6.9999)
		IUSE="${IUSE} stable-branch"
		if use stable-branch; then
			MY_PV_QTCOPY="${PV}-stable"
		else
			MY_PV_QTCOPY="${PV}"
		fi
		;;
	4.5.9999)
		IUSE="${IUSE} +qt-copy"
		if use qt-copy; then
			MY_PV_QTCOPY="${PV}-qt-copy"
		else
			MY_PV_QTCOPY="${PV}"
		fi
		;;
	*)
		MY_PV_QTCOPY="${PV}"
		;;
esac

inherit base eutils multilib toolchain-funcs flag-o-matic git versionator

case "${PV}" in
	4.*.*_beta*)
		SRCTYPE="${SRCTYPE:-opensource-src}"
		MY_PV="${PV/_beta/-beta}"
		;;
	4.*.*_rc*)
		SRCTYPE="${SRCTYPE:-opensource-src}"
		MY_PV="${PV/_rc/-rc}"
		;;
	*)
		SRCTYPE="${SRCTYPE:-opensource-src}"
		MY_PV="${PV}"
		;;
esac

MY_P=qt-x11-${SRCTYPE}-${MY_PV}
S="${WORKDIR}/${MY_P}"

SRC_URI="http://get.qt.nokia.com/qt/source/${MY_P}.tar.bz2"

case "${MY_PV_QTCOPY}" in
	4.?.9999-qt-copy)
		HOMEPAGE="http://qt.gitorious.org/+kde-developers/qt/kde-qt/";;
	*)
		HOMEPAGE="http://qt.nokia.com/";;
esac

if version_is_at_least 4.5 ${PV} ; then
	LICENSE="|| ( LGPL-2.1 GPL-3 )"
fi

case "${MY_PV_QTCOPY}" in
	4.?.9999-qt-copy)
		EGIT_REPO_URI="git://gitorious.org/+kde-developers/qt/kde-qt.git"
		EGIT_PROJECT="qt-${PV}"
		EGIT_BRANCH="4.5.2-patched"
		EGIT_TREE="${EGIT_BRANCH}"
		SRC_URI=
		;;
	4.?.9999 | 4.?.9999-stable)
		EGIT_REPO_URI="git://gitorious.org/qt/qt.git"
		EGIT_PROJECT="qt-${PV}"
		EGIT_BRANCH="${MY_PV_QTCOPY/.9999/}"
		EGIT_TREE="${EGIT_BRANCH}"
		SRC_URI=
		;;
	4.9999-stable)
		EGIT_REPO_URI="git://gitorious.org/qt/qt.git"
		EGIT_PROJECT="qt-${PV}"
		EGIT_BRANCH="master-stable"
		EGIT_TREE="${EGIT_BRANCH}"
		SRC_URI=
		;;
	4.9999)
		EGIT_REPO_URI="git://gitorious.org/qt/qt.git"
		EGIT_PROJECT="qt-${PV}"
		SRC_URI=
		;;
	4.4.?)
		SRC_URI="${SRC_URI} mirror://gentoo/${MY_P}-headers.tar.bz2"
		;;
	*)
		;;
esac

qt4-build-edge_pkg_setup() {
	PATH="${S}/bin:${PATH}"
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	# Make sure ebuilds use the required EAPI
	if [[ ${EAPI} != 2 ]]; then
		ewarn "The qt4-build-edge eclass requires EAPI=2, but this ebuild does not"
		ewarn "have EAPI=2 set. The ebuild author or editor failed. This ebuild needs"
		ewarn "to be fixed. Using qt4-build-edge eclass without EAPI=2 will fail."
		die "qt4-build-edge eclass requires EAPI=2"
	fi

	# Let users know what they are getting themselves into ;-)
	local warnmsg=
	case "${MY_PV_QTCOPY}" in
		4.?.9999-qt-copy)
			warnmsg="The ${PV} version ebuilds with qt-copy USE flag install qt-copy from gitorious kde-qt repository."
			;;
		4.?.9999-stable | 4.9999-stable)
			ewarn "The ${PV} version ebuilds install live git code from Nokia Qt Software - stable branch"
			ewarn "http://labs.trolltech.com/blogs/2009/07/28/getting-the-best-out-of-two-worlds/"
			;;
		4.?.9999 | 4.9999)
			warnmsg="The ${PV} version ebuilds install live git code from Nokia Qt Software."
			;;
		4.*.*_*)
			warnmsg="The ${PV} version ebuilds install a pre-release from Nokia Qt Software."
			;;
		*)
			;;
	esac
	if [[ -n ${warnmsg} ]]; then
		echo
		ewarn ${warnmsg}
		echo
	fi
	if ! version_is_at_least 4.1 $(gcc-version); then
		ewarn "Using a GCC version lower than 4.1 is not supported!"
		echo
	fi
}

qt4-build-edge_src_unpack() {
	setqtenv

	local target= targets=
	for target in configure LICENSE.{GPL2,GPL3} projects.pro \
			src/{qbase,qt_targets,qt_install}.pri \
			bin config.tests mkspecs qmake \
			${QT4_EXTRACT_DIRECTORIES}; do
		targets="${targets} ${MY_P}/${target}"
	done
	case "${MY_PV_QTCOPY}" in
		4.?.9999-qt-copy | 4.?.9999 | 4.9999 | 4.?.9999-stable | 4.9999-stable)
			git_src_unpack
			;;
		*)
			echo tar xjpf "${DISTDIR}"/${MY_P}.tar.bz2 ${targets}
			tar xjpf "${DISTDIR}"/${MY_P}.tar.bz2 ${targets}
			;;
	esac

	# For 4.4.x releases we supply a prepackaged headers tarball
	case "${MY_PV_QTCOPY}" in
		4.4.?)
			echo tar xjpf "${DISTDIR}"/${MY_P}-headers.tar.bz2
			tar xjpf "${DISTDIR}"/${MY_P}-headers.tar.bz2
			;;
	esac
}

qt4-build-edge_src_prepare() {
	setqtenv

	case "${MY_PV_QTCOPY}" in
		4.?.9999-qt-copy | 4.?.9999 | 4.9999 | 4.?.9999-stable | 4.9999-stable)
			generate_include
		;;
	esac

	if [[ ${PN} != qt-core ]]; then
		cd "${S}"
		skip_qmake_build
		skip_project_generation
		symlink_binaries_to_buildtree
	fi

	sed -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		-e "s:X11R6/::" \
		-i "${S}"/mkspecs/$(qt_mkspecs_dir)/qmake.conf \
		|| die "sed ${S}/mkspecs/$(qt_mkspecs_dir)/qmake.conf failed"

	sed -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		-i "${S}"/mkspecs/common/g++.conf \
		|| die "sed ${S}/mkspecs/common/g++.conf failed"

	# Bug 275710
	# Avoid adding C[XX]FLAGS to .qmake.cache as this is used in addition
	# to the mkspecs while building qt
	sed -e "s:SYSTEM_VARIABLES=\"CC CXX CFLAGS CXXFLAGS LDFLAGS\":SYSTEM_VARIABLES=\"CC CXX\":" \
		-i "${S}/configure" || die "sed ${S}/configure failed"

	base_src_prepare
}

qt4-build-edge_src_configure() {
	setqtenv

	myconf="$(standard_configure_options) ${myconf}"
	echo ./configure ${myconf}
	./configure ${myconf} || die "configure failed"

	unset myconf
}

qt4-build-edge_src_compile() {
	setqtenv
	build_directories "${QT4_TARGET_DIRECTORIES}"
}

qt4-build-edge_src_install() {
	setqtenv
	install_directories "${QT4_TARGET_DIRECTORIES}"
	install_qconfigs
	fix_library_files
}

# @FUNCTION: setqtenv
# @DESCRIPTION:
# Prepares the environment. This function is called
# at the beginning of each ebuild phase.
setqtenv() {
	QTBASEDIR=/usr/$(get_libdir)/qt4
	QTPREFIXDIR=/usr
	QTBINDIR=/usr/bin
	QTLIBDIR=/usr/$(get_libdir)/qt4
	QMAKE_LIBDIR_QT=${QTLIBDIR}
	QTPCDIR=/usr/$(get_libdir)/pkgconfig
	QTDATADIR=/usr/share/qt4
	QTDOCDIR=/usr/share/doc/qt-${PV}
	QTHEADERDIR=/usr/include/qt4
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTSYSCONFDIR=/etc/qt4
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTDEMOSDIR=${QTDATADIR}/demos
	QT_INSTALL_PREFIX=/usr/$(get_libdir)/qt4
	PLATFORM=$(qt_mkspecs_dir)

	unset QMAKESPEC
}

# @FUNCTION: standard_configure_options
# @DESCRIPTION:
# Sets up some standard configure options, like libdir (if necessary), whether
# debug info is wanted or not.
standard_configure_options() {
	local myconf=

	[[ $(get_libdir) != "lib" ]] && myconf="${myconf} -L/usr/$(get_libdir)"

	# precompiled headers don't work on hardened, where the flag is masked.
	myconf="${myconf} $(qt_use pch)"

	if use debug; then
		myconf="${myconf} -debug -no-separate-debug-info"
	else
		myconf="${myconf} -release -no-separate-debug-info"
	fi

	# ARCH is set on Gentoo. Qt now falls back to generic on an unsupported
	# $(tc-arch). Therefore we convert it to supported values.
	case "$(tc-arch)" in
		amd64) myconf="${myconf} -arch x86_64" ;;
		ppc|ppc64) myconf="${myconf} -arch powerpc" ;;
		x86|x86-*) myconf="${myconf} -arch i386" ;;
		alpha|arm|ia64|mips|s390|sparc) myconf="${myconf} -arch $(tc-arch)" ;;
		hppa|sh) myconf="${myconf} -arch generic" ;;
		*) die "$(tc-arch) is unsupported by this eclass. Please file a bug." ;;
	esac

	local exceptions=
	has exceptions "${IUSE}" && exceptions="$(qt_use exceptions)"

	myconf="${myconf} -platform $(qt_mkspecs_dir)
		-stl -verbose -largefile -confirm-license -no-rpath
		-prefix ${QTPREFIXDIR} -bindir ${QTBINDIR} -libdir ${QTLIBDIR}
		-datadir ${QTDATADIR} -docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR}
		-plugindir ${QTPLUGINDIR} -sysconfdir ${QTSYSCONFDIR}
		-translationdir ${QTTRANSDIR} -examplesdir ${QTEXAMPLESDIR}
		-demosdir ${QTDEMOSDIR} -silent -fast
		${exceptions}
		$(use x86-fbsd || echo -reduce-relocations)
		-nomake examples -nomake demos"

	case "${MY_PV_QTCOPY}" in
		4.?.9999 | 4.9999 | 4.?.9999-stable | 4.9999-stable | 4.?.9999-qt-copy)
			myconf="${myconf} -opensource"
			;;
	esac

	echo "${myconf}"
}

# @FUNCTION: build_directories
# @USAGE: < directories >
# @DESCRIPTION:
# Compiles the code in ${QT4_TARGET_DIRECTORIES}
build_directories() {
	sed -i -e "s:\$\$\[QT_INSTALL_LIBS\]:${QTLIBDIR}:g" \
		$(find "${S}" -name '*.pr[io]') "${S}"/mkspecs/common/linux.conf \
		|| die "failed to fix QT_INSTALL_LIBS"

	for x in "$@"; do
		pushd "${S}"/${x} > /dev/null || die "can't pushd ${S}/${x}"
		"${S}"/bin/qmake "LIBS+=-L${QTLIBDIR}" "CONFIG+=nostrip" || die "qmake in ${x} failed"
		emake CC=$(tc-getCC) CXX=$(tc-getCXX) LINK=$(tc-getCXX) || die "emake in ${x} failed"
		popd > /dev/null || die "can't popd from ${S}/${x}"
	done
}

# @FUNCTION: install_directories
# @USAGE: < directories >
# @DESCRIPTION:
# run emake install in the given directories, which are separated by spaces
install_directories() {
	for x in "$@"; do
		pushd "${S}"/${x} > /dev/null || die "can't pushd ${S}/${x}"
		emake INSTALL_ROOT="${D}" install || die "emake install in ${x} failed"
		popd > /dev/null || die "can't popd from ${S}/${x}"
	done
}

# @ECLASS-VARIABLE: QCONFIG_ADD
# @DESCRIPTION:
# List options that need to be added to QT_CONFIG in qconfig.pri
QCONFIG_ADD="${QCONFIG_ADD:-}"

# @ECLASS-VARIABLE: QCONFIG_REMOVE
# @DESCRIPTION:
# List options that need to be removed from QT_CONFIG in qconfig.pri
QCONFIG_REMOVE="${QCONFIG_REMOVE:-}"

# @ECLASS-VARIABLE: QCONFIG_DEFINE
# @DESCRIPTION:
# List variables that should be defined at the top of QtCore/qconfig.h
QCONFIG_DEFINE="${QCONFIG_DEFINE:-}"

# @FUNCTION: install_qconfigs
# @DESCRIPTION: Install gentoo-specific mkspecs configurations
install_qconfigs() {
	local x=
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} ]]; then
		for x in QCONFIG_ADD QCONFIG_REMOVE; do
			[[ -n ${!x} ]] && echo ${x}=${!x} >> "${T}"/${PN}-qconfig.pri
		done
		insinto ${QTDATADIR}/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri || die "installing ${PN}-qconfig.pri failed"
	fi

	if [[ -n ${QCONFIG_DEFINE} ]]; then
		for x in ${QCONFIG_DEFINE}; do
			echo "#define ${x}" >> "${T}"/gentoo-${PN}-qconfig.h
		done
		insinto ${QTHEADERDIR}/Gentoo
		doins "${T}"/gentoo-${PN}-qconfig.h || die "installing gentoo-${PN}-qconfig.h failed"
	fi
}

# @FUNCTION: generate_qconfigs
# @DESCRIPTION: Generates gentoo-specific configurations
generate_qconfigs() {
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} || -n ${QCONFIG_DEFINE} || ${CATEGORY}/${PN} == x11-libs/qt-core ]]; then
		local x qconfig_add qconfig_remove qconfig_new
		for x in "${ROOT}${QTDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			[[ -f ${x} ]] || continue
			qconfig_add="${qconfig_add} $(sed -n 's/^QCONFIG_ADD=//p' "${x}")"
			qconfig_remove="${qconfig_remove} $(sed -n 's/^QCONFIG_REMOVE=//p' "${x}")"
		done

		# these error checks do not use die because dying in pkg_post{inst,rm}
		# just makes things worse.
		if [[ -e "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qconfig.pri ]]; then
			# start with the qconfig.pri that qt-core installed
			if ! cp "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qconfig.pri \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri; then
				eerror "cp qconfig.pri failed!"
				return 1
			fi

			# generate list of QT_CONFIG entries from the existing list
			# including qconfig_add and excluding qconfig_remove
			for x in $(sed -n 's/^QT_CONFIG +=//p' \
					"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri) \
					${qconfig_add}; do
				hasq ${x} ${qconfig_remove} || qconfig_new="${qconfig_new} ${x}"
			done

			# replace the existing QT_CONFIG list with qconfig_new
			if ! sed -i -e "s/QT_CONFIG +=.*/QT_CONFIG += ${qconfig_new}/" \
					"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri; then
				eerror "Sed for QT_CONFIG failed!"
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

qt4-build-edge_pkg_postrm() {
	generate_qconfigs
}

qt4-build-edge_pkg_postinst() {
	generate_qconfigs
	echo
	ewarn "After a rebuild or upgrade of Qt, it can happen that Qt plugins (such as Qt"
	ewarn "and KDE styles and widgets) can no longer be loaded. In this situation you"
	ewarn "should recompile the packages providing these plugins. Also, make sure you"
	ewarn "compile the Qt packages, and the packages that depend on it, with the same"
	ewarn "GCC version and the same USE flag settings (especially the debug flag)."
	ewarn
	ewarn "Packages that typically need to be recompiled are kdelibs from KDE4, any"
	ewarn "additional KDE4/Qt4 styles, qscintilla and PyQt4. Before filing a bug report,"
	ewarn "make sure all your Qt4 packages are up-to-date and built with the same"
	ewarn "configuration."
	ewarn
	ewarn "For more information, see http://doc.trolltech.com/${PV%.*}/plugins-howto.html"
	echo
}

# @FUNCTION: skip_qmake_build
# @DESCRIPTION:
# Skip qmake build, as it's already installed by qt-core
skip_qmake_build() {
	sed -i -e 's:if true:if false:g' "${S}"/configure || die "${FUNCNAME}: sed failed."
}

# @FUNCTION: skip_project_generation
# @DESCRIPTION:
# Exit the script early by throwing in an exit before all of the .pro files are scanned
skip_project_generation() {
	sed -i -e 's:echo "Finding:exit 0\n\necho "Finding:g' "${S}"/configure || die "${FUNCNAME}: sed failed."
}

# @FUNCTION: symlink_binaries_to_buildtree
# @DESCRIPTION:
# Symlink generated binaries to buildtree so they can be used during compilation time
symlink_binaries_to_buildtree() {
	for bin in qmake moc uic rcc; do
		ln -s ${QTBINDIR}/${bin} "${S}"/bin/ || die "${FUNCNAME}: symlinking ${bin} to ${S}/bin failed."
	done
}

# required for 9999, easier than sed'ing
generate_include() {
	QTDIR="." perl "bin/syncqt"
}

# @FUNCTION: fix_library_files
# @DESCRIPTION:
# Fixes the pathes in *.la, *.prl, *.pc, as they are wrong due to sandbox and
# moves the *.pc-files into the pkgconfig directory
fix_library_files() {
	local libfile=
	for libfile in "${D}"/${QTLIBDIR}/{*.la,*.prl,pkgconfig/*.pc}; do
		if [[ -e ${libfile} ]]; then
			sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${libfile} || die "${FUNCNAME}: sed on ${libfile} failed."
		fi
	done

	# pkgconfig files refer to ${WORKDIR}/bin, as the moc and uic locations. Fix them.
	for libfile in "${D}"/${QTLIBDIR}/pkgconfig/*.pc; do
		if [[ -e ${libfile} ]]; then
			sed -i -e "s:${S}/bin:${QTBINDIR}:g" ${libfile} || die "${FUNCNAME}: sed on ${libfile} failed."
			# Move .pc files into the pkgconfig directory
			dodir ${QTPCDIR}
			mv ${libfile} "${D}"/${QTPCDIR}/ \
				|| die "${FUNCNAME}: moving ${libfile} to ${D}/${QTPCDIR}/ failed."
		fi
	done

	# Don't install an empty directory
	rmdir "${D}"/${QTLIBDIR}/pkgconfig
}

# @FUNCTION: qt_use
# @USAGE: < flag > [ feature ] [ enableval ]
# @DESCRIPTION:
# This will echo "${enableval}-${feature}" if <flag> is enabled, or
# "-no-${feature} if the flag is disabled. If [feature] is not specified <flag>
# will be used for that. If [enableval] is not specified, it omits the
# assignment-part.
qt_use() {
	local feature="${2:-$1}"
	local enableval=

	[[ -n ${3} ]] && enableval="-${3}"

	if use ${1}; then
		echo "${enableval}-${feature}"
	else
		echo "-no-${feature}"
	fi
}

# @FUNCTION: qt_mkspecs_dir
# @RETURN: the specs-directory w/o path
# @DESCRIPTION:
# Allows us to define which mkspecs dir we want to use.
qt_mkspecs_dir() {
	local spec=
	case ${CHOST} in
		*-freebsd*|*-dragonfly*)
			spec="freebsd" ;;
		*-openbsd*)
			spec="openbsd" ;;
		*-netbsd*)
			spec="netbsd" ;;
		*-darwin*)
			spec="darwin" ;;
		*-linux-*|*-linux)
			spec="linux" ;;
		*)
			die "Unknown CHOST, no platform chosen."
	esac

	CXX=$(tc-getCXX)
	if [[ ${CXX/g++/} != ${CXX} ]]; then
		spec="${spec}-g++"
	elif [[ ${CXX/icpc/} != ${CXX} ]]; then
		spec="${spec}-icc"
	else
		die "Unknown compiler ${CXX}."
	fi

	echo "${spec}"
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postrm pkg_postinst
