# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qt-creator/qt-creator-2.3.0_beta.ebuild,v 1.1 2011/07/18 11:22:02 hwoarang Exp $

EAPI="4"
LANGS="cs de es fr hu it ja pl ru sl uk zh_CN"

inherit qt4-r2 multilib
MY_PN="${PN/-/}"
MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://qt.nokia.com/products/developer-tools"
SRC_URI="http://get.qt.nokia.com/${MY_PN}/${MY_P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="bazaar bineditor bookmarks +cmake cvs debug doc examples fakevim git
	mercurial perforce +qml qtscript rss subversion"
QTVER="4.7.4:4"
DEPEND=">=x11-libs/qt-assistant-${QTVER}[doc?]
	>=x11-libs/qt-sql-${QTVER}
	>=x11-libs/qt-svg-${QTVER}
	debug? ( >=x11-libs/qt-test-${QTVER} )
	!qml? ( >=x11-libs/qt-gui-${QTVER} )
	qml? (
		>=x11-libs/qt-declarative-${QTVER}[private-headers]
		>=x11-libs/qt-core-${QTVER}[private-headers]
		>=x11-libs/qt-gui-${QTVER}[private-headers]
		>=x11-libs/qt-script-${QTVER}[private-headers]
	)
	qtscript? ( >=x11-libs/qt-script-${QTVER} )"

RDEPEND="${DEPEND}
	bazaar? ( dev-vcs/bzr )
	cmake? ( dev-util/cmake )
	cvs? ( dev-vcs/cvs )
	sys-devel/gdb
	examples? ( >=x11-libs/qt-demo-${QTVER} )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( dev-vcs/subversion )"

PLUGINS="bookmarks bineditor cmake cvs fakevim git mercurial
perforce qml qtscript subversion"

S="${WORKDIR}"/"${MY_P}"-src

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0_rc1-qml-plugin.patch
)

src_prepare() {
	qt4-r2_src_prepare

	# fix library path for styleplugin
	sed -i -e "/target.path/s:lib:$(get_libdir):" \
		"${S}"/src/libs/qtcomponents/styleitem/styleitem.pro \
		|| die "Failed to fix multilib dir for styleplugin"

	# bug 263087
	for plugin in ${PLUGINS}; do
		if ! use ${plugin}; then
			einfo "Disabling ${plugin} support"
			if [[ ${plugin} == "cmake" ]]; then
				plugin="cmakeprojectmanager"
			elif [[ ${plugin} == "qtscript" ]]; then
				plugin="qtscripteditor"
			elif [[ ${plugin} ==  "qml" ]]; then
				for x in qmlprojectmanager qmljsinspector qmljseditor qmljstools qmldesigner; do
					einfo "Disabling ${x} support"
					sed -i "/plugin_${x}/s:^:#:" src/plugins/plugins.pro \
						|| die "Failed to disable ${x} plugin"
					done
			fi
			# Now disable the plugins
			sed -i "/plugin_${plugin}/s:^:#:" src/plugins/plugins.pro
		fi
	done

	if use perforce; then
		ewarn
		ewarn "You have enabled perforce plugin."
		ewarn "In order to use it, you need to manually"
		ewarn "download the perforce client from http://www.perforce.com/perforce/downloads/index.html"
		ewarn
	fi
	# disable rss news on startup ( bug #302978 )
	if ! use rss; then
		einfo "Disabling RSS welcome news"
		sed -i "/m_rssFetcher->fetch/s:^:\/\/:" \
			src/plugins/welcome/communitywelcomepagewidget.cpp || die
	fi

	# add rpath to make qtcreator actual find its *own* plugins
	sed -i "/^LIBS/s:+=:& -Wl,-rpath,/usr/$(get_libdir)/${MY_PN} :" qtcreator.pri || die
}

src_configure() {
	#the path must NOT be empty
	local qtheaders="False"
	use qml && qtheaders="/usr/include/qt4/"
	eqmake4 \
		${MY_PN}.pro \
		IDE_LIBRARY_BASENAME="$(get_libdir)" \
		QT_PRIVATE_HEADERS=${qtheaders}
}

src_install() {
	#install wrapper
	dobin bin/${MY_PN} bin/qtpromaker || die "dobin failed"
	if use qml; then
		# qmlpuppet component. Bug #367383
		dobin bin/qmlpuppet || die "Failed to install qmlpuppet component"
	fi
	emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_subtargets || die
	if use doc;then
		emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_inst_qch_docs || die
	fi

	# Install missing icon
	doicon ${FILESDIR}/${MY_PN}_logo_48.png || die "failed to install icon"
	make_desktop_entry ${MY_PN} "Qt Creator" qtcreator_logo_48 \
		'Qt;Development;IDE' || die

	# install additional translations
	insinto /usr/share/${MY_PN}/translations/
	for x in ${LINGUAS}; do
		for lang in ${LANGS}; do
			if [[ ${x} == ${lang} ]]; then
				cd "${S}"/share/${MY_PN}/translations
				lrelease ${MY_PN}_${x}.ts -qm ${MY_PN}_${x}.qm || die
				doins ${MY_PN}_${x}.qm || die
			fi
		done
	done
}
