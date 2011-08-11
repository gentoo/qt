# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
LANGS="de es fr it ja pl ru sl"

inherit qt4-edge git multilib

MY_PN="${PN/-/}"
DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://qt.nokia.com/products/developer-tools"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
EGIT_BRANCH="2.0"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="bazaar bineditor bookmarks +cmake cvs debug doc examples fakevim git
	inspector mercurial perforce +qml qtscript rss subversion"

QTVER="4.7.1:4"
DEPEND=">=x11-libs/qt-assistant-${QTVER}[doc?]
	>=x11-libs/qt-sql-${QTVER}
	>=x11-libs/qt-svg-${QTVER}
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

PLUGINS="bookmarks bineditor cmake cvs fakevim git mercurial perforce
	qml qtscript subversion"

pkg_setup() {
	# change git repo uri if inspector use flag is enabled
	if use inspector; then
		elog

		elog "you should contact the upstream maintainer for inspector"
		elog "plugin bugs. Do _NOT_ file bugs on gentoo bugzilla."
		elog
		elog "Upstream maintainer"
		elog "Enrico Ros <enrico.ros_at_gmail.com>"
		elog "Project page: http://gitorious.org/~enrico"
		elog
		EGIT_REPO_URI="git://gitorious.org/~enrico/${PN}/qt-creator-inspector.git"
		EGIT_BRANCH="inspector-plugin"
		EGIT_COMMIT="${EGIT_BRANCH}"
	fi
	qt4-edge_pkg_setup
}

src_prepare() {
	qt4-edge_src_prepare
	git_src_prepare

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
		ewarn "download perforce client from http://www.perforce.com/perforce/downloads/index.html"
		ewarn
	fi

	#disable rss news on startup ( bug #302978 )
	if ! use rss; then
		einfo "Disabling RSS welcome news"
		sed -i "/m_rssFetcher->fetch/s:^:\/\/:" \
			src/plugins/welcome/communitywelcomepagewidget.cpp \
				|| die "failed to disable rss"
	fi
	# fix translations
	sed -i "/^LANGUAGES/s:=.*:= ${LANGS}:" \
		share/${MY_PN}/translations/translations.pro

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

	emake INSTALL_ROOT="${D}/usr" install_subtargets || die "emake install failed"
	if use doc; then
		emake INSTALL_ROOT="${D}/usr" install_inst_qch_docs || die "emake install qch_docs failed"
	fi

	# Install missing icon
	doicon ${FILESDIR}/${PN}_logo_48.png
	make_desktop_entry ${MY_PN} QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"

	# Remove unneeded translations
	for lang in ${LANGS}; do
		if ! hasq $lang ${LINGUAS}; then
			rm "${D}"/usr/share/${MY_PN}/translations/${MY_PN}_${lang}.qm \
					|| die "failed to remove translations"
		fi
	done
}
