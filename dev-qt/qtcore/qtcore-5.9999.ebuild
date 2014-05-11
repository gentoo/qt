# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="+glib icu"

DEPEND="
	>=dev-libs/libpcre-8.30[pcre16]
	sys-libs/zlib
	virtual/libiconv
	glib? ( dev-libs/glib:2 )
	icu? ( dev-libs/icu:= )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/corelib
)
QCONFIG_DEFINE=( QT_ZLIB )

pkg_setup() {
	QCONFIG_REMOVE=(
		$(usev !glib)
		$(usev !icu)
	)

	qt5-build_pkg_setup
}

src_configure() {
	local myconf=(
		$(qt_use glib)
		-iconv
		$(qt_use icu)
	)
	qt5-build_src_configure
}

# Test dependencies
#
# kernel/qobject/test/test.pro: network
# kernel/qpointer/qpointer.pro: widgets (opt)
# kernel/qmetaproperty/qmetaproperty.pro: gui
# kernel/qeventloop/qeventloop.pro: network
# kernel/qsocketnotifier/qsocketnotifier.pro: network
# kernel/qsignalmapper/qsignalmapper.pro: gui?
# kernel/qmetaobject/qmetaobject.pro: gui
# kernel/qmetaobjectbuilder/qmetaobjectbuilder.pro: gui
# kernel/qmimedata/qmimedata.pro: gui?
# codecs/qtextcodec/test/test.pro: gui?
# xml/qxmlstream/qxmlstream.pro: xml network
# itemmodels/qabstractitemmodel/qabstractitemmodel.pro: gui?
# itemmodels/qitemselectionmodel/qitemselectionmodel.pro: widgets
# itemmodels/qabstractproxymodel/qabstractproxymodel.pro: gui?
# itemmodels/qsortfilterproxymodel/qsortfilterproxymodel.pro: gui widgets
# itemmodels/qidentityproxymodel/qidentityproxymodel.pro: gui?
# itemmodels/qitemmodel/qitemmodel.pro: widgets sql
# statemachine/qstatemachine/qstatemachine.pro: gui widgets (opt)
# animation/qparallelanimationgroup/qparallelanimationgroup.pro: gui
# animation/qpauseanimation/qpauseanimation.pro: gui
# animation/qpropertyanimation/qpropertyanimation.pro: gui widgets
# io/qiodevice/qiodevice.pro: network
# io/qsettings/qsettings.pro: gui
# io/qprocess/testGuiProcess/testGuiProcess.pro: widgets
# io/qprocess/test/test.pro: network
# io/qtextstream/test/test.pro: network
# io/qdatastream/qdatastream.pro: gui?
# io/qfile/test/test.pro: network
