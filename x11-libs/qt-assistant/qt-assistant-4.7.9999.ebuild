# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The assistant help module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="~x11-libs/qt-gui-${PV}[stable-branch=]
	~x11-libs/qt-sql-${PV}[sqlite,stable-branch=]
	~x11-libs/qt-webkit-${PV}[stable-branch=]
	~x11-libs/qt-declarative-${PV}[stable-branch=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	# Pixeltool isn't really assistant related, but it relies on
	# the assistant libraries. doc/qch/
	QT4_TARGET_DIRECTORIES="
		tools/assistant
		tools/pixeltool
		tools/qdoc3"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		tools/
		demos/
		examples/
		src/
		include/
		doc/"

	qt4444-build-edge_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}-tools.patch"
	qt4-build-edge_src_prepare
}

src_configure() {
	myconf="${myconf} -no-xkb -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-multimedia -no-qt3support -no-svg"

	qt4-build-edge_src_configure
}

src_compile() {
	# help libQtHelp find freshly built libQtCLucene (bug #289811)
	export LD_LIBRARY_PATH="${S}/lib"
	export DYLD_LIBRARY_PATH="${S}/lib:${S}/lib/QtHelp.framework"

	qt4-build-edge_src_compile

	# ugly hack to build docs
	cd "${S}"
	qmake "LIBS+=-L${QTLIBDIR}" "CONFIG+=nostrip" projects.pro || die
	emake docs || die
}

src_install() {
	qt4-build-edge_src_install

	# install documentation
	# note that emake install_qchdocs fails for undefined reason
	# so we use a workaround
	cd "${S}"
	insinto "${QTDOCDIR}"
	doins -r "${S}"/doc/qch || die
	dobin "${S}"/bin/qdoc3 || die

	# install correct assistant icon, bug 241208
	dodir /usr/share/pixmaps/ || die
	M
	insinto /usr/share/pixmaps/
	doins tools/assistant/tools/assistant/images/assistant.png || die
	# Note: absolute image path required here!
	make_desktop_entry /usr/bin/assistant Assistant \
		/usr/share/pixmaps/assistant.png 'Qt;Development;GUIDesigner' || die
}
