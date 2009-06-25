# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qt-creator/qt-creator-1.1.0.ebuild,v 1.5 2009/06/23 10:07:16 hwoarang Exp $

EAPI="2"

inherit qt4 multilib

MY_PN="${PN/-/}"
MY_P="${P}-src"

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://labs.qtsoftware.com/page/Projects/Tools/QtCreator"
SRC_URI="http://download.qtsoftware.com/${MY_PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+cmake debug +debugger +designer doc fakevim git kde perforce subversion"

DEPEND=">=x11-libs/qt-assistant-4.5.0_rc1
	>=x11-libs/qt-core-4.5.0_rc1
	>=x11-libs/qt-dbus-4.5.0_rc1
	>=x11-libs/qt-gui-4.5.0_rc1
	>=x11-libs/qt-qt3support-4.5.0_rc1
	>=x11-libs/qt-script-4.5.0_rc1
	>=x11-libs/qt-sql-4.5.0_rc1
	>=x11-libs/qt-svg-4.5.0_rc1
	>=x11-libs/qt-test-4.5.0_rc1
	>=x11-libs/qt-webkit-4.5.0_rc1
	cmake? ( dev-util/cmake )
	debugger? ( sys-devel/gdb )
	git? ( dev-util/git )
	subversion? ( dev-util/subversion )"

RDEPEND="${DEPEND}
	!kde? ( || ( >=x11-libs/qt-phonon-4.5.0_rc1 media-sound/phonon ) )
	kde? ( media-sound/phonon )"

PLUGINS="cmake debugger designer fakevim git perforce subversion"

PATCHES=(
	"${FILESDIR}/docs_gen.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	qt4_src_prepare

	# Ensure correct library installation
	sed -i "s/IDE_LIBRARY_BASENAME\ =\ lib$/IDE_LIBRARY_BASENAME=$(get_libdir)/" \
		qtcreator.pri || die "failed to fix libraries installation"

	# bug 263087
	for plugin in ${PLUGINS};do
		if ! use ${plugin};then
			einfo "Disabling ${plugin} support"
			if [[ ${plugin} == "cmake" ]];then
				plugin="cmakeprojectmanager"
			fi
			sed -i "/plugin_${plugin}/s:^:#:" src/plugins/plugins.pro \
				|| die "Failed to disabled ${plugin} plugin"
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
	eqmake4 ${MY_PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}/usr" install || die "emake install failed"
	if use doc;then
		insinto /usr/share/doc/qtcreator/
		doins "${S}"/share/doc/qtcreator/qtcreator.qch || die "Installing documentation failed"
		doins -r "${S}"/doc/html || die "Installing html documentation  failed"
	fi
	make_desktop_entry qtcreator QtCreator qtcreator_logo_48 \
		'Qt;Development;IDE' || die "make_desktop_entry failed"
}
