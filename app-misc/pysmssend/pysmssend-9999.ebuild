# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5

inherit distutils eutils python multilib git

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.sourceforge.net/"
EGIT_REPO_URI="git://github.com/hwoarang/pysmssend.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

RDEPEND="${DEPEND}
		>=dev-python/mechanize-0.1.9
		qt4? ( >=dev-python/PyQt4-4.3 )"

S="${WORKDIR}/pysmssend"

src_install() {
	distutils_src_install
	dodir /usr/share/${PN}
	if use qt4; then
		insinto /usr/share/${PN}/Icons
		doins   Icons/*
		doicon  Icons/pysmssend.png
		dobin   pysmssend pysmssendcmd
		make_desktop_entry pysmssend pySMSsend pysmssend.png "Applications;Network" 
	else
		dobin   pysmssendcmd
		dosym   pysmssendcmd /usr/bin/pysmssend
	fi
	dodoc	README AUTHORS TODO

}
