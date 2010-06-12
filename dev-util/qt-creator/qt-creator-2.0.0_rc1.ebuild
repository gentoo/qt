# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qt-creator/qt-creator-1.3.1.ebuild,v 1.8 2010/03/07 12:30:31 hwoarang Exp $

EAPI="2"
LANGS="de es fr it ja pl ru sl"

inherit qt4-r2 multilib
MY_PN="${PN/-/}"
MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://qt.nokia.com/products/developer-tools"
SRC_URI="http://get.qt.nokia.com/${MY_PN}/${MY_P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~ppc ~ppc64 ~x86"
IUSE="bineditor bookmarks +cmake cvs debug +designer doc examples fakevim git
	kde mercurial perforce qml qtscript rss subversion"

QTVER="4.7.0_beta1:4"
DEPEND=">x11-libs/qt-assistant-${QTVER}[doc?]"
RDEPEND="${DEPEND}
	>x11-libs/qt-sql-${QTVER}
	>x11-libs/qt-svg-${QTVER}
	>x11-libs/qt-test-${QTVER}
	>x11-libs/qt-webkit-${QTVER}
	!kde? ( || ( >x11-libs/qt-phonon-${QTVER} media-sound/phonon ) )
	kde? ( media-sound/phonon )
	cmake? ( dev-util/cmake )
	cvs? ( dev-util/cvs )
	sys-devel/gdb
	examples? ( >=x11-libs/qt-demo-${QTVER} )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	!qml? ( >=x11-libs/qt-gui-${QTVER}[dbus,qt3support] )
	qml? ( 
		>=x11-libs/qt-declarative-${QTVER}[private-headers] 
		>=x11-libs/qt-core-${QTVER}[private-headers]
		>=x11-libs/qt-gui-${QTVER}[dbus,qt3support,private-headers] 
		>=x11-libs/qt-script-${QTVER}[private-headers] 
	)
	qtscript? ( >x11-libs/qt-script-${QTVER} )
	subversion? ( dev-util/subversion )"

PLUGINS="bookmarks bineditor cmake cvs designer fakevim git mercurial perforce
	qml qtscript subversion"

S="${WORKDIR}"/"${MY_P}"-src

src_prepare() {
	qt4-r2_src_prepare

	# bug 263087
	for plugin in ${PLUGINS}; do
		if ! use ${plugin}; then
			einfo "Disabling ${plugin} support"
			if [[ ${plugin} == "cmake" ]]; then
				plugin="cmakeprojectmanager"
			elif [[ ${plugin} == "qtscript" ]]; then
				plugin="qtscripteditor"
			elif [[ ${plugin} == "qml" ]]; then
				plugins="qmljseditor"
				epatch "${FILESDIR}"/${P}-disable_qml_plugins.patch
			fi
			sed -i "/plugin_${plugin}/s:^:#:" src/plugins/plugins.pro \
				|| die "Failed to disable ${plugin} plugin"
		fi
	done

	if use perforce; then
		ewarn
		ewarn "You have enabled perforce plugin."
		ewarn "In order to use it, you need to manually"
		ewarn "download perforce client from http://www.perforce.com/perforce/downloads/index.html"
		ewarn
	fi
	# disable rss news on startup ( bug #302978 )
	if ! use rss; then
		einfo "Disabling RSS welcome news"
		sed -i "/m_rssFetcher->fetch/s:^:\/\/:" \
			src/plugins/welcome/communitywelcomepagewidget.cpp || die
	fi
}

src_configure() {
	use qml && QTCREATOR_WITH_QML="1"
	eqmake4 ${MY_PN}.pro IDE_LIBRARY_BASENAME="$(get_libdir)"
}

src_install() {
	#install wrapper
	dobin bin/${MY_PN} || die "Failed to install launcher"
	emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_subtargets || die
	if use doc;then
		emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_qch_docs || die
	fi
	make_desktop_entry ${MY_PN} QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die

	# install translations
	insinto /usr/share/${MY_PN}/translations/
	for x in ${LINGUAS}; do
		for lang in ${LANGS}; do
			if [[ ${x} == ${lang} ]]; then
				doins share/${MY_PN}/translations/${MY_PN}_${x}.qm || die
			fi
		done
	done
}
