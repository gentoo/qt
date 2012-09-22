#!/bin/bash

# 
# Script for comparing release ebuilds against live ebuilds
# Author: Markos Chandras <hwoarang@gentoo.org>
#

. /etc/init.d/functions.sh

usage() {
	echo
	echo "./compare-ebuilds.sh <version you want to compare>"
	echo
}

PORTDIR="$(portageq envvar PORTDIR)"
OVERLAY=
LIVE_VERSION="4.8.9999" # you normally don't need to change that

#hacky way to find full path for qt overlay
OVERLAY=$(portageq get_repo_path / qt)

[[ -z ${OVERLAY} ]] && \
	echo "Can't find path for your Qt overlay" && \
	exit 1

[[ -z ${1} ]] && \
	echo "Wrong number of parameters" && \
	usage && exit 1

for x in $(find ${PORTDIR}/x11-libs -type f -name "qt-*-${1}*.ebuild" -printf "%h\n"|uniq);do
	diff -Naur $(find ${x} -type f -name "*-${1}*.ebuild") \
		${OVERLAY}/x11-libs/$(basename ${x})/$(basename ${x})-${LIVE_VERSION}.ebuild
	if [[ $? != 0 ]]; then
		einfo "Press enter if you want to move to the next ebuild"
		einfo "or 'n' if you want to stop now!"
		read resp
		[[ ${resp} == "n" ]] && exit 1
	fi
done

einfo "Sweet! All done!"

exit 0
