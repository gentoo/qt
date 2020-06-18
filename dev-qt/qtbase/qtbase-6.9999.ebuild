# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="dev"
	EGIT_REPO_URI=( "https://code.qt.io/qt/${PN}.git" )
	inherit git-r3
else
	MY_P=everywhere-src-${PV/_/-}
	SRC_URI="https://download.qt.io/development_releases/qt/${PV%.*}/${PV/_/-}/submodules/${MY_P}.tar.xz"
	KEYWORDS="~amd64"
	S=${WORKDIR}/${MY_P}
fi

inherit cmake

DESCRIPTION="Cross-platform application development framework"
HOMEPAGE="https://www.qt.io/"

LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"
SLOT=6/$(ver_cut 1-2)
# Qt Modules
IUSE="+concurrent +dbus +gui +network +sql opengl +widgets +xml"
REQUIRED_USE="opengl? ( gui ) widgets? ( gui )"

QTGUI_IUSE="accessibility egl eglfs evdev +gif gles2-only +ico +jpeg libinput tslib tuio vulkan +X"
QTNETWORK_IUSE="gssapi libproxy sctp +ssl vnc"
QTSQL_IUSE="freetds mysql oci8 odbc postgres +sqlite"
IUSE+=" ${QTGUI_IUSE} ${QTNETWORK_IUSE} ${QTSQL_IUSE} cups gtk icu systemd +udev"
# QtPrintSupport = QtGui + QtWidgets enabled.
# ibus = xkbcommon + dbus, and xkbcommon needs either libinput or X
# moved vnc logically to QtNetwork as that is upstream condition for it
REQUIRED_USE+="
	$(printf '%s? ( gui ) ' ${QTGUI_IUSE//+/})
	$(printf '%s? ( network ) ' ${QTNETWORK_IUSE//+/})
	$(printf '%s? ( sql ) ' ${QTSQL_IUSE//+/})
	accessibility? ( dbus X )
	cups? ( gui widgets )
	eglfs? ( egl )
	gtk? ( widgets )
	gui? ( || ( eglfs X ) || ( libinput X ) )
	libinput? ( udev )
	sql? ( || ( freetds mysql oci8 odbc postgres sqlite ) )
	X? ( gles2-only? ( egl ) )
"

# TODO:
# qtimageformats: mng not done yet, qtimageformats.git upstream commit 9443239c
# qtnetwork: connman, networkmanager
BDEPEND="virtual/pkgconfig"
DEPEND="
	app-arch/zstd:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libpcre2[pcre16,unicode]
	>=dev-util/cmake-3.17.0
	dev-util/gtk-update-icon-cache
	media-libs/fontconfig
	>=media-libs/freetype-2.6.1:2
	>=media-libs/harfbuzz-1.6.0:=
	media-libs/tiff:0
	>=sys-apps/dbus-1.4.20
	sys-libs/zlib:=
	virtual/opengl
	egl? ( media-libs/mesa[egl] )
	gles2-only? ( media-libs/mesa[gles2] )
	freetds? ( dev-db/freetds )
	gssapi? ( virtual/krb5 )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango
	)
	gui? ( media-libs/libpng:0= )
	icu? ( dev-libs/icu:= )
	!icu? ( virtual/libiconv )
	jpeg? ( virtual/jpeg:0 )
	libinput? (
		dev-libs/libinput:=
		>=x11-libs/libxkbcommon-0.5.0
	)
	libproxy? ( net-libs/libproxy )
	mysql? ( dev-db/mysql-connector-c:= )
	oci8? ( dev-db/oracle-instantclient:=[sdk] )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:* )
	sctp? ( kernel_linux? ( net-misc/lksctp-tools ) )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tslib? ( >=x11-libs/tslib-1.21 )
	udev? ( virtual/libudev:= )
	vulkan? ( dev-util/vulkan-headers )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		>=x11-libs/libxcb-1.12:=[xkb]
		>=x11-libs/libxkbcommon-0.5.0[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
RDEPEND="${DEPEND}
	dev-qt/qtchooser
"

# @FUNCTION: qt_feature
# @USAGE: <flag> [feature]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
qt_feature() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"
	echo "-DQT_FEATURE_${2:-$1}=$(usex $1 ON OFF)"
}

src_prepare() {
	cmake_src_prepare

	# TODO: fails without QtGui
	sed -e "/androiddeployqt/s/^/#DONT/" -e "/androidtestrunner/s/^/#DONT/" \
		-i src/tools/CMakeLists.txt || die
}

src_configure() {
	QT6_PREFIX=${EPREFIX}/usr
	QT6_HEADERDIR=${QT6_PREFIX}/include/qt6
	QT6_LIBDIR=${QT6_PREFIX}/$(get_libdir)
	QT6_ARCHDATADIR=${QT6_PREFIX}/$(get_libdir)/qt6
	QT6_BINDIR=${QT6_ARCHDATADIR}/bin
	QT6_PLUGINDIR=${QT6_ARCHDATADIR}/plugins
	QT6_LIBEXECDIR=${QT6_ARCHDATADIR}/libexec
	QT6_IMPORTDIR=${QT6_ARCHDATADIR}/imports
	QT6_QMLDIR=${QT6_ARCHDATADIR}/qml
	QT6_DATADIR=${QT6_PREFIX}/share/qt6
	QT6_DOCDIR=${QT6_PREFIX}/share/qt6-doc
	QT6_TRANSLATIONDIR=${QT6_DATADIR}/translations
	QT6_EXAMPLESDIR=${QT6_DATADIR}/examples
	QT6_TESTSDIR=${QT6_DATADIR}/tests
	QT6_SYSCONFDIR=${EPREFIX}/etc/xdg

	local mycmakeargs=(
		-DINSTALL_BINDIR=${QT6_BINDIR}
# 		-DINSTALL_INCLUDEDIR=${QT6_HEADERDIR}
# TODO: breaks cmake macro:
# CMake Error at cmake/QtBuild.cmake:1997 (file):
#   file STRINGS file
#   "${WORKDIR}/qtbase-6.9999_build/include/qt6/QtOpenGLWidgets/headers.pri"
#   cannot be read.
# Call Stack (most recent call first):
#   cmake/QtBuild.cmake:2503 (qt_read_headers_pri)
#   src/openglwidgets/CMakeLists.txt:7 (qt_add_module)
		-DINSTALL_LIBDIR=${QT6_LIBDIR}
		-DINSTALL_ARCHDATADIR=${QT6_ARCHDATADIR}
		-DINSTALL_PLUGINSDIR=${QT6_PLUGINDIR}
		-DINSTALL_LIBEXECDIR=${QT6_LIBEXECDIR}
		-DINSTALL_QMLDIR=${QT6_QMLDIR}
		-DINSTALL_DATADIR=${QT6_DATADIR}
		-DINSTALL_DOCDIR=${QT6_DOCDIR}
		-DINSTALL_TRANSLATIONSDIR=${QT6_TRANSLATIONDIR}
		-DINSTALL_SYSCONFDIR=${QT6_SYSCONFDIR}
		-DINSTALL_MKSPECSDIR=${QT6_ARCHDATADIR}/mkspecs
		-DINSTALL_EXAMPLESDIR=${QT6_EXAMPLESDIR}
		-DQT_FEATURE_zstd=ON
		$(qt_feature concurrent)
		$(qt_feature dbus)
		$(qt_feature gui)
		$(qt_feature icu)
		$(qt_feature network)
		$(qt_feature sql)
		$(qt_feature systemd journald)
		-DQT_FEATURE_testlib=ON # TODO: install QtTest by default?
		$(qt_feature udev libudev)
		$(qt_feature xml)
	)
	use icu || mycmakeargs+=( -DQT_FEATURE_iconv=ON )
	use gui && mycmakeargs+=(
		$(qt_feature accessibility accessibility_atspi_bridge)
		$(qt_feature egl)
		$(qt_feature eglfs eglfs_egldevice)
		$(qt_feature eglfs eglfs_gbm)
		$(qt_feature evdev)
		$(qt_feature evdev mtdev)
		$(qt_feature gif)
		$(qt_feature jpeg)
		$(qt_feature opengl)
		$(qt_feature gles2-only opengles2)
		$(qt_feature libinput)
		$(qt_feature tslib)
		$(qt_feature tuio tuiotouch)
		$(qt_feature vulkan)
		$(qt_feature widgets)
		$(qt_feature X xcb)
		$(qt_feature X xcb_xlib)
	)
	use widgets && mycmakeargs+=(
		$(qt_feature cups)
		$(qt_feature gtk gtk3)
	)
	if use libinput || use X; then
		mycmakeargs+=( -DQT_FEATURE_xkbcommon=ON )
	fi
	use network && mycmakeargs+=(
		$(qt_feature gssapi)
		$(qt_feature libproxy)
		$(qt_feature sctp)
		$(qt_feature ssl openssl)
		$(qt_feature vnc)
	)
	use sql && mycmakeargs+=(
		$(qt_feature freetds sql_tds)
		$(qt_feature mysql sql_mysql)
		$(qt_feature oci8 sql_oci)
		$(qt_feature odbc sql_odbc)
		$(qt_feature postgres sql_psql)
		$(qt_feature sqlite sql_sqlite)
		$(qt_feature sqlite system_sqlite)
	)
	cmake_src_configure
}
