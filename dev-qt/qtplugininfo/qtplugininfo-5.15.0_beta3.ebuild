# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 plugin metadata dumper"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qtplugininfo
)

src_configure() {
	# Most of qttools require files that are only generated when qmake is
	# run in the root directory.
	# Related bugs: 633776, 676948, and 716514.
	mkdir -p "${QT5_BUILD_DIR}" || die
	qt5_qmake
	cp "${S}"/qttools-config.pri "${QT5_BUILD_DIR}" || die
	qt5-build_src_configure
}
