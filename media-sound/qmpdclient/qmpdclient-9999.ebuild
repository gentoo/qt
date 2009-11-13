# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_REPO_URI="git://github.com/Voker57/qmpdclient.git"
LANGS="pt_BR zh_CN zh_TW"
LANGSLONG="de_DE fr_FR it_IT nl_NL nn_NO no_NO ru_RU sv_SE tr_TR uk_UA"

inherit qt4-edge git

DESCRIPTION="QMPDClient with NBL additions, such as lyrics' display"
HOMEPAGE="http://bitcheese.net/wiki/QMPDClient"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug dbus"

DEPEND="x11-libs/qt-gui:4[dbus?]"
RDEPEND="${DEPEND}"
DOCS="README AUTHORS THANKSTO Changelog"

src_prepare() {
	# Fix the install path
	sed -i -e "s:PREFIX = /usr/local:PREFIX = /usr:" qmpdclient.pro \
		|| die "sed failed (install path)"

	# nostrip fix
	sed -i -e "s:CONFIG += :CONFIG += nostrip :" qmpdclient.pro \
		|| die "sed failed (nostrip)"

	sed -i -e "s:+= -O2 -g0 -s:+= -O2 -g0:" qmpdclient.pro \
		|| die "sed failed (nostrip)"

	# fix installation folder name
	sed -i "s/share\/QMPDClient/share\/qmpdclient/" src/config.cpp \
		|| die "failed to fix installation directory"

	# check dbus
	if ! use dbus; then
		sed -i -e "s/message(DBus notifier:\ enabled)/message(DBus notifier:\ disabled)/" \
			-e "s/CONFIG\ +=\ nostrip\ qdbus//" \
			-e "/SOURCES\ +=\ src\/notifications_dbus.cpp/SOURCES\ +=\ src\/notifications_nodbus.cpp" \
				${PN}.pro || die "disabling dbus failed"
	fi
}

src_compile() {
	qt4-edge_src_compile
	emake translate || die "failed to generate translations"
}

src_install() {
	qt4-edge_src_install
	for res in 16 22 64 ; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins icons/qmpdclient${res}.png ${PN}.png || die "Installing icons failed"
	done
}
