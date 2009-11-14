# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-edge 

DESCRIPTION="Qt4 application to adjust layouts by xkb"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Antico+XKB?content=101667"
SRC_URI="http://www.php-developer.com.ua/antico/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

LANGS="ru"
for L in $LANGS; do
	IUSE="$IUSE linguas_$L"
done

DEPEND="x11-libs/libxkbfile
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4"
RDEPEND="${DEPEND}"

DOCS="NEWS"

src_prepare() {
	local langs=
	local langsX=
	for L in $LINGUAS; do
		if has ${L} $LANGS; then
			langs="${langs} language/axkb_${L}.ts"
			langsX="${langsX} language/axkb_${L}.qm"
		fi
	done
	sed -i -e "s:^\(TRANSLATIONS = \).*:\1 ${langs}:" AXKB.pro ||
		die "sed failed"
	sed -i -e "s:^\(translations.files += \).*:\1 ${langsX}:" AXKB.pro ||
		die "sed failed"
}
