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
IUSE="bineditor bookmarks +cmake cvs debug +designer doc examples fakevim git
	inspector kde mercurial perforce qml qtscript subversion"

QTVER="4.7.0_pre9999"
DEPEND=">=x11-libs/qt-assistant-${QTVER}:4
	>=x11-libs/qt-gui-${QTVER}:4[dbus,qt3support]"
RDEPEND="${DEPEND}
	>=x11-libs/qt-sql-${QTVER}:4
	>=x11-libs/qt-svg-${QTVER}:4
	>=x11-libs/qt-test-${QTVER}:4
	>=x11-libs/qt-webkit-${QTVER}:4
	!kde? ( || ( >=x11-libs/qt-phonon-${QTVER}:4 media-sound/phonon ) )
	kde? ( media-sound/phonon )
	cmake? ( dev-util/cmake )
	cvs? ( dev-util/cvs )
	sys-devel/gdb
	examples? ( >=x11-libs/qt-demo-${QTVER}:4 )
	git? ( dev-vcs/git )
	inspector? ( >=sci-libs/vtk-5.4[qt4] )
	mercurial? ( dev-vcs/mercurial )
	qml? ( >=x11-libs/qt-declarative-${QTVER}:4 )
	qtscript? ( >=x11-libs/qt-script-${QTVER}:4 )
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
	fi
}

src_configure() {
	if use inspector; then
		export QTCREATOR_WITH_INSPECTOR="true"
		export QTCREATOR_WITH_INSPECTOR_VTK="true"
	fi
	mkdir ${WORKDIR}/build
	cd "${WORKDIR}"/build
	eqmake4 "${S}/${MY_PN}.pro" \
		IDE_LIBRARY_BASENAME=$(get_libdir) \
		IDE_LIBRARY_PATH=$(get_libdir)/${MY_PN} \
		IDE_BUILD_TREE="${WORKDIR}/build" \
		IDE_SOURCE_TREE=${S} \
		QMAKE_RPATHDIR="/usr/$(get_libdir)/${MY_PN}"
}

src_compile() {
	cd "${WORKDIR}/build"
	emake || die "emake failed"
}

src_install() {
	cd "${WORKDIR}/build"
	emake INSTALL_ROOT="${D}/usr" install_subtargets || die "emake install failed"
	if use doc; then
		emake INSTALL_ROOT="${D}/usr" install_qch_docs || die "emake install qch_docs failed"
	fi
	# fix binary name bug 275859
	mv "${D}"/usr/bin/${MY_PN}.bin "${D}"/usr/bin/${MY_PN} || die "failed to
		rename executable"

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
