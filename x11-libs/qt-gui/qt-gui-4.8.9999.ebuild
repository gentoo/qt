# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils qt4-build-edge

DESCRIPTION="The GUI module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="+accessibility cups dbus +glib gif gtk jpeg mng nas nis png +raster tiff trace
private-headers qt3support xinerama"

RDEPEND="media-libs/fontconfig
	>=media-libs/freetype-2
	media-libs/libpng
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXfont
	x11-libs/libSM
	x11-libs/libXi
	~x11-libs/qt-core-${PV}[debug=,glib=,qt3support=]
	~x11-libs/qt-script-${PV}[debug=]
	cups? ( net-print/cups )
	dbus? ( ~x11-libs/qt-dbus-${PV}[debug=] )
	jpeg? ( virtual/jpeg )
	gtk? ( x11-libs/gtk+:2 )
	mng? ( >=media-libs/libmng-1.0.9 )
	nas? ( >=media-libs/nas-1.5 )
	tiff? ( media-libs/tiff )
	xinerama? ( x11-libs/libXinerama )
	"
DEPEND="${RDEPEND}
	xinerama? ( x11-proto/xineramaproto )
	gtk? ( || ( >=x11-libs/cairo-1.10.0[-qt4] <x11-libs/cairo-1.10.0 ) )
	x11-proto/xextproto
	x11-proto/inputproto"
PDEPEND="qt3support? ( ~x11-libs/qt-qt3support-${PV}[debug=] )"

pkg_setup() {
	if ! use qt3support; then
		ewarn "WARNING: if you need 'qtconfig', you _must_ enable qt3support."
		ebeep 5
	fi
	QT4_TARGET_DIRECTORIES="
	src/gui
	src/scripttools/
	tools/designer
	tools/linguist/linguist
	src/plugins/imageformats/gif
	src/plugins/imageformats/ico
	src/plugins/imageformats/jpeg
	src/plugins/inputmethods"

	QT4_EXTRACT_DIRECTORIES="
	include
	src
	tools/linguist/phrasebooks
	tools/linguist/shared
	tools/shared"

	qt4-build-edge_pkg_setup
}

src_unpack() {
	use dbus && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} tools/qdbus/qdbusviewer"
	use mng && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} src/plugins/imageformats/mng"
	use tiff && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} src/plugins/imageformats/tiff"
	use accessibility && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES} src/plugins/accessible/widgets"
	use trace && QT4_TARGET_DIRECTORIES="${QT4_TARGET_DIRECTORIES}	src/plugins/graphicssystems/trace"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES} ${QT4_EXTRACT_DIRECTORIES}"

	qt4-build-edge_src_unpack
}

src_prepare() {
	qt4-build-edge_src_prepare

	# Don't build plugins this go around, because they depend on qt3support lib
	sed -i -e "s:CONFIG(shared:# &:g" "${S}"/tools/designer/src/src.pro
}

src_configure() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	myconf="$(qt_use accessibility)
		$(qt_use cups)
		$(qt_use glib)
		$(qt_use jpeg libjpeg system)
		$(qt_use mng libmng system)
		$(qt_use nis)
		$(qt_use tiff libtiff system)
		$(qt_use dbus qdbus)
		$(qt_use dbus)
		$(qt_use qt3support)
		$(qt_use gtk gtkstyle)
		$(qt_use xinerama)"

	use gif || myconf="${myconf} -no-gif"

	use nas	&& myconf="${myconf} -system-nas-sound"
	use raster && myconf="${myconf} -graphicssystem raster"

	myconf="${myconf} -system-libpng -system-libjpeg
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2
		-no-sql-odbc -xrender -xrandr -xkb -xshape -sm -no-svg"

	# Explicitly don't compile these packages.
	# Emerge "qt-webkit", "qt-phonon", etc for their functionality.
	myconf="${myconf} -no-webkit -no-phonon -no-opengl"

	qt4-build-edge_src_configure
}

src_install() {
	QCONFIG_ADD="x11sm xshape xcursor xfixes xrandr xrender xkb fontconfig
		$(usev accessibility) $(usev xinerama) $(usev cups) $(usev nas)
		gif png system-png system-jpeg
		$(use mng && echo system-mng)
		$(use tiff && echo system-tiff)"
	QCONFIG_REMOVE="no-gif no-png"
	QCONFIG_DEFINE="$(use accessibility && echo QT_ACCESSIBILITY)
			$(use cups && echo QT_CUPS) QT_FONTCONFIG QT_IMAGEFORMAT_JPEG
			$(use mng && echo QT_IMAGEFORMAT_MNG)
			$(use nas && echo QT_NAS)
			$(use nis && echo QT_NIS) QT_IMAGEFORMAT_PNG QT_SESSIONMANAGER QT_SHAPE
			$(use tiff && echo QT_IMAGEFORMAT_TIFF) QT_XCURSOR
			$(use xinerama && echo QT_XINERAMA) QT_XFIXES QT_XKB QT_XRANDR QT_XRENDER"

	qt4-build-edge_src_install

	# remove some unnecessary headers
	rm -f "${D}${QTHEADERDIR}"/{Qt,QtGui}/{qmacstyle_mac.h,qwindowdefs_win.h} \
		"${D}${QTHEADERDIR}"/QtGui/QMacStyle

	# qt-creator
	# some qt-creator headers are located
	# under /usr/include/qt4/QtDesigner/private.
	# those headers are just includes of the headers
	# which are located under tools/designer/src/lib/*
	# So instead of installing both, we create the private folder
	# and drop tools/designer/src/lib/* headers in it.
	dodir /usr/include/qt4/QtDesigner/private/
	insinto /usr/include/qt4/QtDesigner/private/
	doins "${S}"/tools/designer/src/lib/shared/*
	doins "${S}"/tools/designer/src/lib/sdk/*
	#install private headers
	if use private-headers; then
		insinto ${QTHEADERDIR}/QtGui/private
		find "${S}"/src/gui -type f -name "*_p.h" -exec doins {} \;
	fi

	# install correct designer and linguist icons, bug 241208
	doicon tools/linguist/linguist/images/icons/linguist-128-32.png \
		tools/designer/src/designer/images/designer.png \
		|| die "doicon failed"
	# Note: absolute image path required here!
	make_desktop_entry /usr/bin/linguist Linguist \
			/usr/share/pixmaps/linguist-128-32.png \
			'Qt;Development;GUIDesigner' \
			|| die "linguist make_desktop_entry failed"
	make_desktop_entry /usr/bin/designer Designer \
			/usr/share/pixmaps/designer.png \
			'Qt;Development;GUIDesigner' \
			|| die "designer make_desktop_entry failed"
}
