# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Qt5 module for inter-process communication over the D-Bus protocol"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
	>=sys-apps/dbus-1.4.20
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/corelib
	src/dbus
	src/tools/qdbusxml2cpp
	src/tools/qdbuscpp2xml
)

QT5_GENTOO_CONFIG=(
	:dbus
	:dbus-linked:
)

src_prepare() {
	qt5-build_src_prepare

	cat > "${S}/src/corelib/corelib.pro" <<-_EOF_ || die
		QT         =
		TARGET     = QtCore
		load(qt_module)
	_EOF_
}

src_configure() {
	local myconf=(
		-dbus-linked
	)
	qt5-build_src_configure
}

src_install() {
	QT5_TARGET_SUBDIRS=(
		src/dbus
		src/tools/qdbusxml2cpp
		src/tools/qdbuscpp2xml
	)
	qt5-build_src_install
}

src_compile() {
	hack() {
		emake
		if [[ ${subdir} = "src/corelib" ]]; then
			rm "${S}"/lib/libQt5Core* || die
		fi
	}
	qt5_foreach_target_subdir hack
}
