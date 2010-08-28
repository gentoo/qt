# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/~qtbynokia/qt/simulator-qt.git"
EGIT_BRANCH="4.7"
#EGIT_BRANCH="4.7.0-beta1"

inherit git multilib qt4-r2 toolchain-funcs

DESCRIPTION="Qt Simulator is a simulator for Qt applications intended to run on Nokia devices"
HOMEPAGE="http://labs.trolltech.com/page/Projects/Tools/QtSimulator"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS=""
IUSE="dbus debug qt3support xmlpatterns multimedia phonon svg webkit script"

DEPEND="~x11-libs/qt-gui-${PV}"
RDEPEND="${DEPEND}"

pkg_setup() {
	PLATFORM="simulator"
}

src_unpack() {
	git_src_unpack
	qt4-r2_src_unpack
}

src_prepare() {
	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CXXFLAGS} :" \
		"${S}/qmake/Makefile.unix" || die "sed qmake/Makefile.unix
			CXXFLAGS failed"
	sed -i -e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" \
		"${S}/qmake/Makefile.unix" || die "sed
			qmake/Makefile.unix LDFLAGS failed"
	sed -i '/^QMAKE_CFLAGS_\(RELEASE\|DEBUG\)/s:+=.*:+=:' \
		mkspecs/common/g++.conf
	sed -e "s:\(^SYSTEM_VARIABLES\):CC=$(tc-getCC)\nCXX=$(tc-getCXX)\nCFLAGS=\"${CFLAGS}\"\nCXXFLAGS=\"${CXXFLAGS}\"\nLDFLAGS=\"${LDFLAGS}\"\n\1:" \
		-i configure || die "sed qmake compilers failed"
	find ./config.tests/unix -name "*.test" -type f -exec grep -lZ \$MAKE '{}' \; | \
		xargs -0 \
			sed -e "s:\(\$MAKE\):\1 CC=$(tc-getCC) CXX=$(tc-getCXX) LD=$(tc-getCXX) LINK=$(tc-getCXX):g" \
				-i || die "sed test compilers failed"
}

src_configure() {
	local myconf=""
	local datadir="/usr/share/qt4"
	local libdir="/usr/$(get_libdir)/qt4"

	myconf+="-prefix /usr
		-prefix-install
		-hostprefix     '/usr' 
		-libdir         '${libdir}' 
		-headerdir      '/usr/include/qt4' 
		-plugindir      '${libdir}/plugins' 
		-docdir         '/usr/share/doc/${PF}' 
		-demosdir       '${datadir}/demos' 
		-examplesdir    '${datadir}/examples' 
		-sysconfdir     '/etc/qt4' 
		-translationdir '${datadir}/translations' 
		-opensource -confirm-license -stl -verbose
		"

	for module in ${IUSE}; do
		if [ ${module} = "debug" ]; then
			myconf+=" $(use debug && echo -debug || echo -release)"
		else
			myconf+=" $(use ${module} && echo -${module} || echo -no-${module})"
		fi
	done
	! use webkit && myconf+=" -no-javascript-jit"

	./configure ${myconf} || die "configure failed"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		LINK="$(tc-getCXX)" || die "emake failed"
}
