# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar da de en es fa fi fr hi it nb pl pt ro ru sv"
# TODO: forcing 3rdparty libs PLOCALES+=" ja ko zh_CN zh_TW"

inherit qt5-build l10n

DESCRIPTION="Virtual keyboard plugin for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="handwriting +spell +xcb"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtsvg-${PV}
	spell? ( app-text/hunspell:= )
	xcb? ( x11-libs/libxcb:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local myqmakeargs=(
		$(usex handwriting CONFIG+=lipi-toolkit "")
		$(usex spell "" CONFIG+=disable-hunspell)
		$(usex xcb "" CONFIG+=disable-desktop)
	)

	local x
	for x in $(l10n_get_locales); do
		use linguas_${x} && myqmakeargs+=( CONFIG+=lang-${x} )
	done

	qt5-build_src_configure
}
