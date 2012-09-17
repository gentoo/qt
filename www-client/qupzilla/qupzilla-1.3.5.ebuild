# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/qupzilla/qupzilla-1.3.1.ebuild,v 1.3 2012/08/16 10:01:11 johu Exp $

EAPI=4
PLOCALES="cs de el es fa fr hu it ja nl pl pt ru sk sr_BA sr_RS sv uk zh_CN zh_TW"
inherit l10n multilib qt4-r2 vcs-snapshot

MY_P="QupZilla-${PV}"

DESCRIPTION="Qt WebKit web browser"
HOMEPAGE="http://www.qupzilla.com/"
SRC_URI="https://github.com/downloads/QupZilla/qupzilla/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus debug kde nonblockdialogs"

DEPEND="
	>=x11-libs/qt-core-4.7:4
	>=x11-libs/qt-gui-4.7:4
	>=x11-libs/qt-script-4.7:4
	>=x11-libs/qt-sql-4.7:4
	>=x11-libs/qt-webkit-4.7:4
	dbus? ( >=x11-libs/qt-dbus-4.7:4 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS BUILDING CHANGELOG FAQ README.md TODO"

src_configure() {
	# see BUILDING document for explanation of options
	export QUPZILLA_PREFIX=${EPREFIX}/usr/
	export USE_LIBPATH=${QUPZILLA_PREFIX}$(get_libdir)
	export DISABLE_DBUS=$(use dbus && echo false || echo true)
	export KDE=$(use kde && echo true || echo false) # in future this will enable nepomuk integration
	export NONBLOCK_JS_DIALOGS=$(use nonblockdialogs && echo true || echo false)
	has_version '>=x11-libs/qt-webkit-4.8.0:4' && export USE_QTWEBKIT_2_2=true

	# needs qt-webkit with webgl enabled (which we currently don't)
	# export USE_WEBGL=$(use webgl && echo true || echo false)

	eqmake4
}

src_install() {
	qt4-r2_src_install
	l10n_for_each_disabled_locale_do rm_loc
}

rm_loc() {
	rm "${D}"/usr/share/${PN}/locale/qt_${1}.qm || die
}
