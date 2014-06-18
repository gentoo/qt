# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} == "9999" ]]; then
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/QupZilla/${PN}.git"
	KEYWORDS=""
else
	VCS_ECLASS=vcs-snapshot
	MY_P="QupZilla-${PV}"
	SRC_URI="mirror://github/QupZilla/${PN}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}
fi

inherit multilib qt4-r2 ${VCS_ECLASS}

DESCRIPTION="Qt WebKit web browser"
HOMEPAGE="http://www.qupzilla.com/"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus debug kde nonblockdialogs"

DEPEND="
	>=dev-qt/qtcore-4.7:4
	>=dev-qt/qtgui-4.7:4
	>=dev-qt/qtscript-4.7:4
	>=dev-qt/qtsql-4.7:4
	>=dev-qt/qtwebkit-4.7:4
	dbus? ( >=dev-qt/qtdbus-4.7:4 )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS BUILDING CHANGELOG FAQ README.md"

src_prepare() {
	# remove outdated copies of localizations:
	rm -rf bin/locale || die
}

src_configure() {
	# see BUILDING document for explanation of options
	export QUPZILLA_PREFIX=${EPREFIX}/usr/
	export USE_LIBPATH=${QUPZILLA_PREFIX}$(get_libdir)
	export DISABLE_DBUS=$(use dbus && echo false || echo true)
	export KDE=$(use kde && echo true || echo false) # in future this will enable nepomuk integration
	export NONBLOCK_JS_DIALOGS=$(use nonblockdialogs && echo true || echo false)
	has_version '>=dev-qt/qtwebkit-4.8.0:4' && export USE_QTWEBKIT_2_2=true

	# needs qtwebkit with webgl enabled (which we currently don't)
	# export USE_WEBGL=$(use webgl && echo true || echo false)

	eqmake4
}
