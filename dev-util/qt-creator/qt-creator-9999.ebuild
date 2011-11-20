# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
LANGS="cs de es fr hu it ja pl ru sl uk zh_CN"

inherit qt4-edge git multilib

MY_PN="${PN/-/}"
DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://qt.nokia.com/products/developer-tools"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
if [[ ${PV} == 2.9999 ]]; then
	EGIT_BRANCH="2.0"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="bazaar bineditor bookmarks +botan-bundled +cmake cvs debug doc examples fakevim git
	mercurial perforce +qml qtscript rss subversion"

QTVER="4.7.4:4"
CDEPEND=">=x11-libs/qt-assistant-${QTVER}[doc?]
	>=x11-libs/qt-sql-${QTVER}
	>=x11-libs/qt-svg-${QTVER}
	!qml? ( >=x11-libs/qt-gui-${QTVER} )
	qml? (
		>=x11-libs/qt-declarative-${QTVER}[private-headers(+)]
		>=x11-libs/qt-core-${QTVER}[private-headers(+)]
		>=x11-libs/qt-gui-${QTVER}[private-headers(+)]
		>=x11-libs/qt-script-${QTVER}[private-headers(+)]
	)
	qtscript? ( >=x11-libs/qt-script-${QTVER} )
	!botan-bundled? ( =dev-libs/botan-1.8* )"

DEPEND="${CDEPEND}
	!botan-bundled? ( dev-util/pkgconfig )"

RDEPEND="${CDEPEND}
	bazaar? ( dev-vcs/bzr )
	cmake? ( dev-util/cmake )
	cvs? ( dev-vcs/cvs )
	sys-devel/gdb[python]
	examples? ( >=x11-libs/qt-demo-${QTVER} )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( dev-vcs/subversion )"

PLUGINS="bookmarks bineditor cmake cvs fakevim git mercurial perforce
	qml qtscript rss subversion"

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
			elif [[ ${plugin} == "rss" ]]; then
				plugin="welcome"
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

	# fix translations
	sed -i "/^LANGUAGES/s:=.*:= ${LANGS}:" \
		share/${MY_PN}/translations/translations.pro || die

	# add rpath to make qtcreator actual find its *own* plugins
	sed -i "/^LIBS/s:+=:& -Wl,-rpath,/usr/$(get_libdir)/${MY_PN} :" qtcreator.pri || die

	if ! use botan-bundled; then
		# identify system botan and pkg-config file
		local botan_version=$(best_version dev-libs/botan | cut -d '-' -f3 | \
			cut -d '.' -f1,2)
		local lib_botan=$(pkg-config --libs botan-${botan_version})
		einfo "Major version of system's botan library to be used: ${botan_version}"

		# drop bundled libBotan. Bug #383033
		rm -rf "${S}"/src/libs/3rdparty/botan || die
		# remove references to bundled botan
		sed -i -e "s:botan::" "${S}"/src/libs/3rdparty/3rdparty.pro || die
		for x in testrunner parsertests modeldemo; do
			sed -i -e "/botan.pri/d" "${S}"/tests/valgrind/memcheck/${x}.pro || die
		done
		sed -i -e "/botan.pri/d" "${S}"/src/libs/utils/utils_dependencies.pri || die
		sed -i -e "/botan.pri/d" "${S}"/tests/manual/preprocessor/preprocessor.pro || die
		# link to system botan
		sed -i -e "/LIBS/s:$: ${lib_botan}:" "${S}"/${MY_PN}.pri || die
		sed -i -e "s:-lBotan:${lib_botan}:" "${S}"/tests/manual/appwizards/appwizards.pro || die
		# append botan refs to compiler flags
		append-flags $(pkg-config --cflags --libs botan-${botan_version})
	fi

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


src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	#install wrapper
	dobin bin/${MY_PN} bin/qtpromaker
	if use qml; then
		# qmlpuppet component. Bug #367383
		dobin bin/qmlpuppet
	fi

	emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_subtargets
	if use doc; then
		[[ -e "${S}"/share/doc/${MY_PN}/${MY_PN}.qch ]] || due "${MY_PN}.qch is	missing"
		emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_qch_docs
	fi

	# Install missing icon
	doicon "${FILESDIR}"/${MY_PN}_logo_48.png || die "failed to install icon"
	make_desktop_entry ${MY_PN} "Qt Creator" qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"

	# Remove unneeded translations
	for lang in ${LANGS}; do
		if ! has $lang ${LINGUAS}; then
			rm "${D}"/usr/share/${MY_PN}/translations/${MY_PN}_${lang}.qm \
					|| die "failed to remove translations"
		fi
	done
}
