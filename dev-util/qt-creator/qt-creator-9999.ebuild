# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
LANGS="cs de es fr hu it ja pl ru sl uk zh_CN"

inherit multilib eutils flag-o-matic qt4-edge git-2

MY_P=${PN}-${PV/_/-}-src

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://qt.nokia.com/products/developer-tools"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git
	https://git.gitorious.org/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

QTC_PLUGINS=(bazaar cmake:cmakeprojectmanager cvs fakevim
	git madde mercurial perforce subversion valgrind)
IUSE="+botan-bundled debug doc examples ${QTC_PLUGINS[@]%:*}"

QTVER="4.7.4:4"
CDEPEND="
	>=x11-libs/qt-core-${QTVER}[private-headers(+)]
	>=x11-libs/qt-declarative-${QTVER}[private-headers(+)]
	>=x11-libs/qt-gui-${QTVER}[private-headers(+)]
	>=x11-libs/qt-script-${QTVER}[private-headers(+)]
	>=x11-libs/qt-sql-${QTVER}
	>=x11-libs/qt-svg-${QTVER}
	debug? ( >=x11-libs/qt-test-${QTVER} )
	>=x11-libs/qt-assistant-${QTVER}[doc?]
	!botan-bundled? ( =dev-libs/botan-1.8* )
"
DEPEND="${CDEPEND}
	!botan-bundled? ( dev-util/pkgconfig )
"
RDEPEND="${CDEPEND}
	sys-devel/gdb[python]
	examples? ( >=x11-libs/qt-demo-${QTVER} )
"
PDEPEND="
	bazaar? ( dev-vcs/bzr )
	cmake? ( dev-util/cmake )
	cvs? ( dev-vcs/cvs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( dev-vcs/subversion )
	valgrind? ( dev-util/valgrind )
"

src_prepare() {
	qt4-edge_src_prepare

	# disable unwanted plugins
	for plugin in "${QTC_PLUGINS[@]#[+-]}"; do
		if ! use ${plugin%:*}; then
			einfo "Disabling ${plugin%:*} plugin"
			sed -i -e "/^[[:space:]]\+plugin_${plugin#*:}/d" src/plugins/plugins.pro \
				|| die "failed to disable ${plugin} plugin"
		fi
	done

	if use perforce; then
		ewarn
		ewarn "You have enabled the perforce plugin."
		ewarn "In order to use it, you need to manually download the perforce client from"
		ewarn "  http://www.perforce.com/perforce/downloads/index.html"
		ewarn
	fi

	# fix translations
	sed -i -e "/^LANGUAGES/s:=.*:= ${LANGS}:" \
		share/qtcreator/translations/translations.pro || die

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
		sed -i -e "/LIBS/s:$: ${lib_botan}:" "${S}"/qtcreator.pri || die
		sed -i -e "s:-lBotan:${lib_botan}:" "${S}"/tests/manual/appwizards/appwizards.pro || die
		# append botan refs to compiler flags
		append-flags $(pkg-config --cflags --libs botan-${botan_version})
	fi
}

src_configure() {
	eqmake4 qtcreator.pro \
		IDE_LIBRARY_BASENAME="$(get_libdir)" \
		IDE_PACKAGE_MODE=true
}

src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install

	if use doc; then
		emake INSTALL_ROOT="${D%/}${EPREFIX}/usr" install_docs
	fi

	# Install icon & desktop file
	doicon src/plugins/coreplugin/images/logo/128/qtcreator.png || die
	make_desktop_entry qtcreator 'Qt Creator' qtcreator 'Qt;Development;IDE' || die

	# Remove unneeded translations
	local lang
	for lang in ${LANGS}; do
		if ! has ${lang} ${LINGUAS}; then
			rm "${D}"/usr/share/qtcreator/translations/qtcreator_${lang}.qm \
				|| eqawarn "failed to remove ${lang} translation"
		fi
	done
}
