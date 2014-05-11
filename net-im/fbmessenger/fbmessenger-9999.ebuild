# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python3_2 )

EGIT_REPO_URI="https://github.com/oconnor663/linuxmessenger"

inherit git-2 distutils-r1

DESCRIPTION="A Linux clone of Facebook Messenger for Windows made with PyQt"
HOMEPAGE="https://github.com/oconnor663/linuxmessenger"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/PyQt4[webkit,phonon,${PYTHON_USEDEP}]"
