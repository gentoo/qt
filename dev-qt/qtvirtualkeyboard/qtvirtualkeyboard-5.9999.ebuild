# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="ar da de en es fa fi fr hi it ja ko nb pl pt ru sv zh_CN zh_TW"

inherit qt5-build l10n

DESCRIPTION="Virtual keyboard plugin for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="+spell +xcb handwriting"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	spell? ( app-text/hunspell )
	xcb? ( x11-libs/libxcb )
"
RDEPEND="${DEPEND}"

src_configure() {

	local myqmakeargs=(
		$(usex spell '' 'CONFIG+=disable-hunspell')
		$(usex xcb '' 'CONFIG+=disable-desktop')
		$(usex handwriting 'CONFIG+=lipi-toolkit')
	)

	for x in ${PLOCALES}; do
		use linguas_${x} && myqmakeargs+=("CONFIG+=lang-${x}")
	done

	qt5-build_src_configure
}
