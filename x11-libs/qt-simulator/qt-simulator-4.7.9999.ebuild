# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://gitorious.org/~qtbynokia/qt/simulator-qt.git"
EGIT_BRANCH="4.7"
#EGIT_BRANCH="4.7.0-beta1"

inherit git multilib qt4-r2

DESCRIPTION="Qt Simulator is a simulator for Qt applications intended to run on Nokia devices"
HOMEPAGE="http://labs.trolltech.com/page/Projects/Tools/QtSimulator"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS=""
IUSE="debug qt3support xmlpatterns multimedia phonon svg webkit javascript-jit \
script dbus"

DEPEND=">=x11-libs/qt-gui-4.6.9999"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	qt4-r2_src_unpack
}

src_configure() {
	local myconf=""
	local datadir="/usr/share/qt4"
	local libdir="/usr/$(get_libdir)/qt4"

	myconf+="-prefix    '/usr' 
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
		-opensource 
		"
	
	for module in ${IUSE}; do
		if [ ${module} = "debug" ]; then
			myconf+=" $(use debug && echo -debug || echo -release)"
		else
			myconf+=" $(use ${module} && echo -${module} || echo -no-${module})"
		fi
	done

	./configure ${myconf} || die "configure failed"
}
