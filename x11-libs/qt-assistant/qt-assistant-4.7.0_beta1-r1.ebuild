# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build

DESCRIPTION="The assistant help module for the Qt toolkit"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc +glib trace"

DEPEND="~x11-libs/qt-gui-${PV}[glib=,trace?]
	~x11-libs/qt-sql-${PV}[sqlite]
	~x11-libs/qt-webkit-${PV}
	~x11-libs/qt-declarative-${PV}"
RDEPEND="${DEPEND}"

# Pixeltool isn't really assistant related, but it relies on
# the assistant libraries. doc/qch/
QT4_TARGET_DIRECTORIES="
	tools/assistant
	tools/pixeltool
	tools/qdoc3"
QT4_EXTRACT_DIRECTORIES="
	tools/
	demos/
	examples/
	src/
	include/
	doc/"

pkg_setup() {
	use trace && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		tools/qttracereplay"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		${QT4_EXTRACT_DIRECTORIES}"
	qt4-build_pkg_setup
}

src_configure() {
	myconf="${myconf} -no-xkb -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-multimedia -no-qt3support -no-svg"
	! use glib && myconf="${myconf} -no-glib"
	qt4-build_src_configure
}

src_compile() {
	# help libQtHelp find freshly built libQtCLucene (bug #289811)
	export LD_LIBRARY_PATH="${S}/lib:${QTLIBDIR}"
	export DYLD_LIBRARY_PATH="${S}/lib:${S}/lib/QtHelp.framework"

	qt4-build_src_compile

	# ugly hack to build docs
	cd "${S}"
	qmake "LIBS+=-L${QTLIBDIR}" "CONFIG+=nostrip" projects.pro || die
	emake qch_docs || die "emake qch_docs failed"
	if use doc; then
		emake docs || die "emake docs failed"
	fi
	qmake "LIBS+=-L${QTLIBDIR}" "CONFIG+=nostrip" projects.pro || die
}

src_install() {
	qt4-build_src_install
	cd "${S}"
	emake INSTALL_ROOT="${D}" install_qchdocs \
		|| die "failed to install qch docs"
	if use doc; then
		emake INSTALL_ROOT="${D}" install_htmldocs \
			|| die "failed to install htmldocs"
	fi
	dobin "${S}"/bin/qdoc3 || die "Failed to install qdoc3"
	# install correct assistant icon, bug 241208
	dodir /usr/share/pixmaps/ || die
	insinto /usr/share/pixmaps/
	doins tools/assistant/tools/assistant/images/assistant.png || die
	# Note: absolute image path required here!
	make_desktop_entry /usr/bin/assistant Assistant \
		/usr/share/pixmaps/assistant.png 'Qt;Development;GUIDesigner' || die
}
