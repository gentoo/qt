# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge git multilib
MY_PN="${PN/-/}"

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://labs.qtsoftware.com/page/Projects/Tools/QtCreator"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="bineditor bookmarks +cmake cvs debug +debugger +designer doc examples fakevim git kde mercurial perforce qml qtscript subversion"

DEPEND=">=x11-libs/qt-assistant-4.6.0_alpha_pre1:4
	>=x11-libs/qt-gui-4.6.0_alpha_pre1:4[dbus,qt3support]"

RDEPEND="${DEPEND}
	>=x11-libs/qt-sql-4.6.1:4
	>=x11-libs/qt-svg-4.6.1:4
	>=x11-libs/qt-test-4.6.1:4
	>=x11-libs/qt-webkit-4.6.1:4
	!kde? ( || ( >=x11-libs/qt-phonon-4.6.1:4 media-sound/phonon ) )
	kde? ( media-sound/phonon )
	cmake? ( dev-util/cmake )
	cvs? ( dev-util/cvs )
	debugger? ( sys-devel/gdb )
	examples? ( >=x11-libs/qt-demo-4.6.1:4 )
	git? ( dev-util/git )
	mercurial? ( dev-util/mercurial )
	qml? ( >=x11-libs/qt-declarative-4.6.1:4 )
	qtscript? ( >=x11-libs/qt-script-4.6.1:4 )
	subversion? ( dev-util/subversion )"

PLUGINS="bookmarks bineditor cmake cvs debugger designer fakevim git mercurial perforce qml qtscript subversion"

LANGS="de es fr it ja pl ru sl"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

src_prepare() {
	qt4-edge_src_prepare

	# bug 263087
	for plugin in ${PLUGINS};do
		if ! use ${plugin};then
			einfo "Disabling ${plugin} support"
			if [[ ${plugin} == "cmake" ]];then
				plugin="cmakeprojectmanager"
			elif [[ ${plugin} == "qtscript" ]];then
				plugin="qtscripteditor"
			fi
			if [[ ${plugin} == "qml" ]]; then
				plugin="qmleditor"
				einfo "Disabling qmlprojectmanager support"
				sed -i "/plugin_qmlprojectmanager/s:^:#:" src/plugins/plugins.pro \
					|| die "Failed to disable ${plugin} plugin"
			fi
			sed -i "/plugin_${plugin}/s:^:#:" src/plugins/plugins.pro \
				|| die "Failed to disable ${plugin} plugin"
		fi
	done

	if use perforce;then
		ewarn
		ewarn "You have enabled perforce plugin."
		ewarn "In order to use it, you need to manually"
		ewarn "download perforce client from http://www.perforce.com/perforce/downloads/index.html"
		ewarn
		ebeep 5
	fi
}

src_configure() {
	eqmake4 IDE_LIBRARY_BASENAME="$(get_libdir)"
}

src_install() {
	emake INSTALL_ROOT="${D}/usr" install_subtargets || die "emake install failed"
	# fix binary name bug 275859
	mv "${D}"/usr/bin/${MY_PN}.bin "${D}"/usr/bin/${MY_PN} || die "failed to rename executable"
	if use doc;then
		emake INSTALL_ROOT="${D}/usr" install_qch_docs || die "emake install qch_docs failed"
	fi
	make_desktop_entry ${MY_PN} QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"

	# install translations
	insinto /usr/share/${MY_PN}/translations/
	for x in ${LINGUAS};do
		for lang in ${LANGS};do
			if [[ ${x} == ${lang} ]];then
				doins share/${MY_PN}/translations/${MY_PN}_${x}.qm \
					|| die "failed to install translations"
			fi
		done
	done
}
