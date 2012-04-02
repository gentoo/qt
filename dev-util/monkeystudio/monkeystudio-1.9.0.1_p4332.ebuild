# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
LANGS="be es fr ru"

inherit qt4-r2

MY_P="mks_${PV/_p/-svn}-src"

DESCRIPTION="A cross platform Qt 4 IDE"
HOMEPAGE="http://monkeystudio.sourceforge.net/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="|| ( GPL-2 GPL-3 LGPL-3 )"
SLOT="0"
IUSE="doc"

RDEPEND=">=x11-libs/qt-assistant-4.7.0:4
	>=x11-libs/qt-core-4.7.0:4
	>=x11-libs/qt-gui-4.7.0:4
	>=x11-libs/qt-sql-4.7.0:4
	x11-libs/qscintilla"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.5.8 )"

DOCS="ChangeLog readme.txt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e "s:datas/\*:datas/apis datas/scripts datas/templates:" \
		-i installs.pri || die "sed installs.pri failed"

	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 build.pro prefix=/usr system_qscintilla=1
}

src_install() {
	qt4-r2_src_install

	insinto /usr/share/${PN}/translations
	local lang
	for lang in ${LANGS} ; do
		if use linguas_${lang} ; then
			doins datas/translations/monkeystudio_${lang}.qm
		fi
	done

	fperms 755 /usr/bin/${PN}

	if use doc ; then
		doxygen || die "doxygen failed"
		dohtml -r doc/html/*
	fi
}
