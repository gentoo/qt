# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_PN="QupZilla"
MY_P=${MY_PN}-${PV}

if [[ ${PV} == *9999* ]]; then
	VCS_ECLASS=git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="git://github.com/${MY_PN}/${PN}.git"
else
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://github.com/${MY_PN}/${PN}/releases/download/v${PV}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}/${MY_P}
fi

PLOCALES="ar_SA bg_BG ca_ES cs_CZ de_DE el_GR es_ES es_MX es_VE eu_ES fa_IR fi_FI fr_FR gl_ES he_IL hr_HR hu_HU id_ID it_IT ja_JP ka_GE lg lv_LV nl_NL nqo pl_PL pt_BR pt_PT ro_RO ru_RU sk_SK sr sr@ijekavian sr@ijekavianlatin sr@latin sv_SE tr_TR uk_UA uz@Latn zh_CN zh_TW"
PLUGINS_HASH='7c66cb2efbd18eacbd04ba211162b1a042e5b759'
PLUGINS_VERSION='2015.06.05' # if there are no updates, we can use the older archive

inherit eutils l10n multilib qmake-utils ${VCS_ECLASS}

DESCRIPTION="Qt WebKit web browser"
HOMEPAGE="http://www.qupzilla.com/"
SRC_URI+="https://github.com/${MY_PN}/${PN}-plugins/archive/${PLUGINS_HASH}.tar.gz -> ${PN}-plugins-${PLUGINS_VERSION}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus debug gnome-keyring nonblockdialogs"

RDEPEND="dev-libs/openssl:0
	>=dev-qt/qtconcurrent-5.6:5
	>=dev-qt/qtcore-5.6:5
	>=dev-qt/qtgui-5.6:5
	>=dev-qt/qtnetwork-5.6:5
	>=dev-qt/qtprintsupport-5.6:5
	>=dev-qt/qtsql-5.6:5[sqlite]
	>=dev-qt/qtwebengine-5.6:5[widgets]
	>=dev-qt/qtwidgets-5.6:5
	x11-libs/libX11
	dbus? ( >=dev-qt/qtdbus-5.6:5 )
	gnome-keyring? ( gnome-base/gnome-keyring )"
DEPEND="${RDEPEND}
	>=dev-qt/linguist-tools-5.6:5
	virtual/pkgconfig"

DOCS=( AUTHORS BUILDING CHANGELOG FAQ README.md )

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		unpack ${A}
	else
		default
	fi
}

src_prepare() {
	rm_loc() {
		# remove localizations the user has not specified
		sed -i -e "/${1}.ts/d" translations/translations.pri || die
		rm translations/${1}.ts || die
	}

	# patch bundled but changed QTSA for Qt-5.5, see bugs 548470 and 489142
	epatch "${FILESDIR}"/qtsingleapplication-QDataStream.patch

	epatch_user

	# remove outdated prebuilt localizations
	rm -rf bin/locale || die

	# remove empty locale
	rm translations/empty.ts || die

	# get extra plugins into qupzilla build tree
	mv "${WORKDIR}"/${PN}-plugins-${PLUGINS_HASH}/plugins/* "${S}"/src/plugins/ || die

	l10n_find_plocales_changes "translations" "" ".ts"
	l10n_for_each_disabled_locale_do rm_loc
}

src_configure() {
	# see BUILDING document for explanation of options
	export \
		QUPZILLA_PREFIX="${EPREFIX}/usr/" \
		USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)" \
		DISABLE_DBUS=$(usex dbus '' 'true') \
		NONBLOCK_JS_DIALOGS=$(usex nonblockdialogs 'true' '')

	eqmake5 $(use gnome-keyring && echo "DEFINES+=GNOME_INTEGRATION")
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
