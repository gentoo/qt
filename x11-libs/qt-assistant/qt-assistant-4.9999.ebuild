# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The assistant help module for the Qt toolkit."
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-sql-${PV}
	!alpha? ( !ia64? ( !ppc? ( ~x11-libs/qt-webkit-${PV}  ) ) )
	"

# Pixeltool isn't really assistant related, but it relies on
# the assistant libraries. doc/qch/
QT4_TARGET_DIRECTORIES="
tools/assistant
tools/pixeltool
tools/qdoc3"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}"

pkg_setup() {
	qt4-build-edge_pkg_setup

	if ! built_with_use x11-libs/qt-sql sqlite; then
		die "You must first emerge x11-libs/qt-sql with the \"sqlite\" use flag in order to use qt-assistant"
	fi
}

src_configure() {
	myconf="${myconf} -no-xkb -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-opengl -no-qt3support -no-svg"
	qt4-build-edge_src_configure
}

src_compile() {
	qt4-build-edge_src_compile
	# ugly hack to build docs
	cd ${S}
	export LD_LIBRARY_PATH="${S}/lib"
	qmake "LIBS+=-L${QTLIBDIR}" "CONFIG+=nostrip" projects.pro || die "qmake projects faied"
	emake qch_docs || die "emake docs failed"
}

src_install() {
	qt4-build-edge_src_install
	# install documentation
	# note that emake install_qchdocs fails for undefined reason so we use a
	# workaround
	cd "${S}"
	insinto ${QTDOCDIR}
	doins -r "${S}"/doc/qch || die "doins qch documentation failed"
	#emake INSTALL_ROOT="${D}" install_qchdocs || die "emake install_qchdocs	failed"
	domenu "${FILESDIR}"/Assistant.desktop || die "domenu failed"
}
