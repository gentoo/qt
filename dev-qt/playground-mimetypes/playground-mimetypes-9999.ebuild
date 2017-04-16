# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5


inherit eutils qt4-r2 git-2

DESCRIPTION=""
HOMEPAGE="https://github.com/qtproject/playground-mimetypes"
LICENSE="LGPL-2.1"

	EGIT_REPO_URI="git://github.com/qtproject/${PN}.git
		https://github.com/qtproject/${PN}.git"

SLOT="0"
KEYWORDS="amd64 x86"

# minimum Qt version required
QT_PV="4.7.2:4"

DEPEND="
	>=dev-qt/qtcore-${QT_PV}
"
