# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-build-edge

DESCRIPTION="The GUI module(s) for the Qt toolkit."
LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS=""

IUSE_INPUT_DEVICES="input_devices_wacom"
IUSE="+accessibility cups dbus debug glib mng nas nis tiff +qt3support xinerama ${IUSE_INPUT_DEVICES}"

RDEPEND="
	
	media-libs/fontconfig
	>=media-libs/freetype-2
	media-libs/jpeg
	media-libs/libpng
	sys-libs/zlib
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXfont
	x11-libs/libSM
	~x11-libs/qt-core-${PV}[glib=,qt3support=]
	~x11-libs/qt-script-${PV}
	cups? ( net-print/cups )
	dbus? ( ~x11-libs/qt-dbus-${PV} )
	input_devices_wacom? ( x11-libs/libXi x11-drivers/linuxwacom )
	mng? ( >=media-libs/libmng-1.0.9 )
	nas? ( >=media-libs/nas-1.5 )
	tiff? ( media-libs/tiff )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/inputproto"
PDEPEND="qt3support? ( ~x11-libs/qt-qt3support-${PV} )"

QT4_TARGET_DIRECTORIES="
src/gui
tools/designer
tools/linguist
src/plugins/imageformats/gif
src/plugins/imageformats/ico
src/plugins/imageformats/jpeg"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}"

src_unpack() {
	use dbus && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} tools/qdbus/qdbusviewer"
	use mng && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} src/plugins/imageformats/mng"
	use tiff && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} src/plugins/imageformats/tiff"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	${QT4_EXTRACT_DIRECTORIES}"

	qt4-build-edge_src_unpack

	# Don't build plugins this go around, because they depend on qt3support lib
	sed -i -e "s:CONFIG(shared:# &:g" "${S}"/tools/designer/src/src.pro

	# fixing hardcoded fonts, bug #252312
	epatch ${FILESDIR}/hardcoded_fonts.patch
}

src_configure() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"
	myconf="$(qt_use accessibility)
		$(qt_use cups)
		$(qt_use glib)
		$(qt_use input_devices_wacom tablet)
		$(qt_use mng libmng system)
		$(qt_use nis)
		$(qt_use tiff libtiff system)
		$(qt_use dbus qdbus)
		$(qt_use qt3support)
		$(qt_use xinerama)"

	use nas	&& myconf="${myconf} -system-nas-sound"

	myconf="${myconf} -qt-gif -system-libpng -system-libjpeg
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-xrender -xrandr -xkb -xshape -sm  -no-svg"

	# Explictly don't compile these packages.
	# Emerge "qt-webkit", "qt-phonon", etc for their functionality.
	myconf="${myconf} -no-webkit -no-phonon -no-dbus -no-opengl"

	qt4-build-edge_src_configure
}

src_install() {
	QCONFIG_ADD="x11sm xshape xcursor xfixes xrandr xrender xkb fontconfig
		$(usev accessibility) $(use input_devices_wacom && echo tablet)
		$(usev xinerama) $(usev cups) $(usev nas) gif png system-png system-jpeg
		$(use mng && echo system-mng) $(use tiff && echo system-tiff)"
	QCONFIG_REMOVE="no-gif no-png"
	QCONFIG_DEFINE="$(use accessibility && echo QT_ACCESSIBILITY)
	$(use cups && echo QT_CUPS) QT_FONTCONFIG QT_IMAGEFORMAT_JPEG
	$(use mng && echo QT_IMAGEFORMAT_MNG) $(use nas && echo QT_NAS)
	$(use nis && echo QT_NIS) QT_IMAGEFORMAT_PNG QT_SESSIONMANAGER QT_SHAPE
	$(use tiff && echo QT_IMAGEFORMAT_TIFF) QT_XCURSOR
	$(use xinerama && echo QT_XINERAMA) QT_XFIXES QT_XKB QT_XRANDR QT_XRENDER"
	qt4-build-edge_src_install

	# remove some unnecessary headers
	rm -f "${D}${QTHEADERDIR}"/{Qt,QtGui}/{qmacstyle_mac.h,qwindowdefs_win.h} \
		"${D}${QTHEADERDIR}"/QtGui/QMacStyle
	dodir /usr/include/qt4/QtDesigner/private/
	insinto /usr/include/qt4/QtDesigner/private/
	doins "${S}"/tools/designer/src/lib/shared/*
	doins "${S}"/tools/designer/src/lib/sdk/*
	
	#creating icons
	dodir /usr/share/pixmaps/ || die "dodir failed"
	insinto /usr/share/pixmaps/
	doins "${S}"/tools/linguist/linguist/images/icons/linguist-128-32.png \
		"${S}"/tools/designer/src/designer/images/designer.png || die "doins failed"
	make_desktop_entry /usr/bin/linguist Linguist \
		linguist-128-32.png 'Qt;Development;GUIDesigner' \
		|| die "make_desktop_entry failed"
	make_desktop_entry /usr/bin/designer Designer \
		designer.png	'Qt;Development;GUIDesigner' \
		|| die "make_desktop_entry failed"
}
