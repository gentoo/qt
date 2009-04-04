#!/bin/bash
#
# Markos Chandras(hwoarang@gentoo.org)
#
# Script for synchronizing live packages using tree packages as reference
#
#
source /etc/init.d/functions.sh
#### VARIABLES ####
STARTDIR="`pwd|xargs dirname|xargs dirname`"
PORTDIR="$(portageq envvar PORTDIR)"
V2SYNC="4.5.0"
##################
# NOTE: We dont sync qt-assistant since live has a different build system
for package in qt-{core,dbus,demo,gui,opengl,phonon,qt3support,script,sql,svg,test,webkit,xmlpatterns};do
	einfo "Synchronizing ${package}"
	pushd ${STARTDIR}/x11-libs/${package}
	cp ${PORTDIR}/x11-libs/${package}/${package}-${V2SYNC}.ebuild ${package}-4.5.9999.ebuild
	cp ${PORTDIR}/x11-libs/${package}/${package}-${V2SYNC}.ebuild ${package}-4.9999.ebuild
	#fix inherited eclass
	sed -i "s/qt4-build/qt4-build-edge/" ${package}-4.5.9999.ebuild
	sed -i "s/qt4-build/qt4-build-edge/" ${package}-4.9999.ebuild
	#fix header
	sed -i "s/#\ \$Header:.*/#\ \$Header:\ \$/" ${package}-4.5.9999.ebuild
	sed -i "s/#\ \$Header:.*/#\ \$Header:\ \$/" ${package}-4.9999.ebuild
	#drop keywords
	sed -i "s/KEYWORDS=.*/KEYWORDS=\"\"/" ${package}-4.5.9999.ebuild
	sed -i "s/KEYWORDS=.*/KEYWORDS=\"\"/" ${package}-4.9999.ebuild
	repoman manifest
	echangelog "Sync with portage packages"
	popd
done
ewarn "Make sure to review ebuilds before committing."
ewarn "The following fixes are required before committing the ebuilds"
ewarn "1) qt-gui packages : remove patch from src_prepare"
ewarn "2) qt-demo packages: remove patch from src_prepare"
