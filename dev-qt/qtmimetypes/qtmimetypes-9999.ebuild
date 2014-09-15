# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit qt4-r2

DESCRIPTION="Qt4 Implementation of Qt5 Mimetypes API"
HOMEPAGE="https://qt.gitorious.org/qtplayground/mimetypes"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=( "git://gitorious.org/qtplayground/mimetypes.git"
					"https://gitorious.org/qtplayground/mimetypes.git" )
fi

LICENSE="|| ( GPL-3 LGPL-2.1 )"
SLOT="0"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qttest:4"
RDEPEND="${DEPEND}"
