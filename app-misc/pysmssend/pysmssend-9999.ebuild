# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

NEED_PYTHON=2.5

inherit distutils eutils python multilib cvs

ECVS_SERVER="pysmssend.cvs.sourceforge.net/cvsroot/pysmssend/"
ECVS_MODULE="pysmssend"

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.sourceforge.net/"

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
