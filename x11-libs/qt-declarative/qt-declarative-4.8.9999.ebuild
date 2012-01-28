# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
if [[ ${PV} != 4*9999 ]]; then
	KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
else
	KEYWORDS=""
fi

IUSE="+accessibility qt3support webkit"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-gui-${PV}[accessibility=,aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-opengl-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-script-${PV}[aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-sql-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	~x11-libs/qt-svg-${PV}[accessibility=,aqua=,c++0x=,qpa=,debug=]
	~x11-libs/qt-xmlpatterns-${PV}[aqua=,c++0x=,qpa=,debug=]
	qt3support? ( ~x11-libs/qt-qt3support-${PV}[accessibility=,aqua=,c++0x=,qpa=,debug=] )
	webkit? ( ~x11-libs/qt-webkit-${PV}[aqua=,c++0x=,qpa=,debug=] )
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	QCONFIG_ADD="declarative"

	QT4_TARGET_DIRECTORIES="
		src/declarative
		src/imports
		tools/designer/src/plugins/qdeclarativeview
		tools/qml
		tools/qmlplugindump"

	if use webkit; then
		QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
			src/3rdparty/webkit/Source/WebKit/qt/declarative"
	fi

	QT4_EXTRACT_DIRECTORIES="
		include/
		src/
		tools/
		translations/"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} -declarative -no-gtkstyle
			$(qt_use accessibility) $(qt_use qt3support) $(qt_use webkit)"
	qt4-build-edge_src_configure
}

src_install() {
	qt4-build-edge_src_install
	if use aqua && [[ ${CHOST##*-darwin} -ge 9 ]] ; then
		insinto "${QTLIBDIR#${EPREFIX}}"/QtDeclarative.framework/Headers/private
		# ran for the 2nd time, need it for the updated headers
		fix_includes
	else
		insinto "${QTHEADERDIR#${EPREFIX}}"/QtDeclarative/private
	fi
	find "${S}"/src/declarative/ -type f -name "*_p.h" -exec doins {} \;
}
