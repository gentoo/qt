# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-edge git multilib

MY_PN="${PN/-/}"
DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://qt.nokia.com/products/developer-tools"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="bineditor bookmarks +cmake cvs debug +designer doc examples fakevim git
	inspector kde mercurial perforce qml qtscript rss subversion"

QTVER="4.7.0_beta1:4"
DEPEND=">=x11-libs/qt-assistant-${QTVER}[doc?]
	>=x11-libs/qt-gui-${QTVER}[dbus,qt3support]"
RDEPEND="${DEPEND}
	>=x11-libs/qt-sql-${QTVER}
	>=x11-libs/qt-svg-${QTVER}
	>=x11-libs/qt-test-${QTVER}
	>=x11-libs/qt-webkit-${QTVER}
	!kde? ( || ( >=x11-libs/qt-phonon-${QTVER} media-sound/phonon ) )
	kde? ( media-sound/phonon )
	cmake? ( dev-util/cmake )
	cvs? ( dev-util/cvs )
	sys-devel/gdb
	examples? ( >=x11-libs/qt-demo-${QTVER} )
	git? ( dev-vcs/git )
	inspector? ( >=sci-libs/vtk-5.4[qt4] )
	mercurial? ( dev-vcs/mercurial )
	!qml? ( >=x11-libs/qt-gui-${QTVER}[dbus,qt3support] )
	qml? (
		>=x11-libs/qt-declarative-${QTVER}[private-headers]
		>=x11-libs/qt-core-${QTVER}[private-headers]
		>=x11-libs/qt-gui-${QTVER}[dbus,qt3support,private-headers]
		>=x11-libs/qt-script-${QTVER}[private-headers]
	)
	qtscript? ( >=x11-libs/qt-script-${QTVER} )
	subversion? ( dev-util/subversion )"

PLUGINS="bookmarks bineditor cmake cvs designer fakevim git mercurial perforce
	qml qtscript subversion"

LANGS="de es fr it ja pl ru sl"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

pkg_setup() {
	# change git repo uri if inspector use flag is enabled
	if use inspector; then
		elog
		elog "You have enabled inspector plugin for qt-creator."
		elog "Please note that this is a thrird-party ebuild hence"
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
				epatch "${FILESDIR}"/disable_qml_plugins.patch
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

	#disable rss news on startup ( bug #302978 )
	if ! use rss; then
		einfo "Disabling RSS welcome news"
		sed -i "/m_rssFetcher->fetch/s:^:\/\/:" \
			src/plugins/welcome/communitywelcomepagewidget.cpp \
				|| die "failed to disable rss"
	fi
}

src_configure() {
	eqmake4 ${MY_PN}.pro IDE_LIBRARY_BASENAME="$(get_libdir)"
}

src_install() {
	#install wrapper
	dobin bin/${MY_PN} || die "failed to install launcher"
	emake INSTALL_ROOT="${D}/usr" install_subtargets || die "emake install failed"
	if use doc; then
		emake INSTALL_ROOT="${D}/usr" install_qch_docs || die "emake install qch_docs failed"
	fi

	make_desktop_entry ${MY_PN} QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"

	# install translations
	insinto /usr/share/${MY_PN}/translations/
	for x in ${LINGUAS}; do
		for lang in ${LANGS}; do
			if [[ ${x} == ${lang} ]]; then
				doins share/${MY_PN}/translations/${MY_PN}_${x}.qm \
					|| die "failed to install translations"
			fi
		done
	done
}
