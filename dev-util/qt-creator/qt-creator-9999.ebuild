# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4 multilib git

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://trolltech.com/developer/qt-creator"

EGIT_REPO_URI="git://labs.trolltech.com/qt-creator/"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-assistant-4.5.0_beta1
	>=x11-libs/qt-core-4.5.0_beta1
	>=x11-libs/qt-dbus-4.5.0_beta1
	>=x11-libs/qt-gui-4.5.0_beta1
	>=x11-libs/qt-qt3support-4.5.0_beta1
	>=x11-libs/qt-script-4.5.0_beta1
	>=x11-libs/qt-sql-4.5.0_beta1
	>=x11-libs/qt-svg-4.5.0_beta1
	>=x11-libs/qt-test-4.5.0_beta1
	>=x11-libs/qt-webkit-4.5.0_beta1"

RDEPEND="${DEPEND}
	|| ( media-sound/phonon >=x11-libs/qt-phonon-4.5.0_beta1 )"

src_unpack() {
	git_src_unpack
	epatch ${FILESDIR}/fix_headers.patch
}

src_compile() {
	eqmake4 qtcreator.pro || die "eqmake4 failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dobin bin/qtcreator || die "dobin failed"
	# installing libraries as the Makefile doesnt
	insinto /usr/$(get_libdir)/ || die "insinto failed"
	doins -r lib/* || die "doins failed"
	# need to delete the broken symlinks
	cd "${D}"/usr/$(get_libdir)
	rm -v libAggregation.so{,.1,.1.0} libCPlusPlus.so{,.1,.1.0} libExtensionSystem.so{,.1,.1.0}
	rm -v libQtConcurrent.so{,.1,.1.0} libUtils.so{,.1,.1.0}
	einfo "Creating symlinks"
	# the symlinks arent kept from the ${S} folder so I need to 
	# recreate them on destination folder.
	# We MUST NOT use dosym cause we get several QA notices about creating
	# absolute symlinks on relative directory
	for lib in Aggregation CPlusPlus ExtensionSystem QtConcurrent Utils ; do
		ln -s lib${lib}.so.1.0.0 lib${lib}.so || die "dosym failed"
		ln -s lib${lib}.so.1.0.0 lib${lib}.so.1 || die "dosym failed"
		ln -s lib${lib}.so.1.0.0 lib${lib}.so.1.0 || die "dosym failed"
	done
	make_desktop_entry qtcreator QtCreator designer.png \
		'Qt;Development;GUIDesigner' || die "make_desktop_entry failed"
}
