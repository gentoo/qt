# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://git.berlios.de/goldendict/"

inherit git qt4-r2

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.berlios.de/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug kde"

# LANGS="af bg ca cs cy da de el en eo es et fo fr ga gl he hr hu ia id it ku lt lv mi mk ms nb nl nn pl pt ro ru sk sl sv sw tn uk zu"
# IUSE+="addons"
# for i in ${LANGS}; do
# 	IUSE="${IUSE} linguas_${i}"
# done

# let's have some dictionaries, english-pronouncing pack and updated morphology
# RUPACK="enruen-content"
# RUPACK_V="1.1"
# MORPH_V="1.0"
# SRC_URI+="addons? (
# 		linguas_en? ( mirror://berlios//"${PN}/en_US_${MORPH_V}".zip -> morphology_dict-en_US_"${MORPH_V}".zip
# 				linguas_ru? ( mirror://berlios//"${PN}/${RUPACK}-${RUPACK_V}".tar.bz2 ) )
# 	)"

RDEPEND=">=app-text/hunspell-1.2
	media-libs/libogg
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libXtst
	>=x11-libs/qt-core-4.5:4[exceptions]
	>=x11-libs/qt-gui-4.5:4[exceptions]
	>=x11-libs/qt-webkit-4.5:4[exceptions]
	kde? ( media-sound/phonon )
	!kde? ( || (
		media-sound/phonon
		>=x11-libs/qt-phonon-4.5:4[exceptions]
	) )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P}/src

PATCHES=(
	"${FILESDIR}/phonon-headers.patch"
)

src_unpack() {
	S=${WORKDIR}/${P} git_src_unpack
}
# 	if use addons; then
# 		[ -d addons ] || mkdir -p "${WORKDIR}"/addons/content/morphology
# 		# get en<->ru funny pack
# 		if use linguas_en && use linguas_ru; then
# 			cd "${WORKDIR}"/addons
# 			unpack "${RUPACK}-${RUPACK_V}.tar.bz2"
# 		fi
# 		# get updated morphology
# 		cd "${WORKDIR}"/addons/content/morphology || die
# 		for i in en de ru; do
# 			local I=$(echo ${i}|tr a-z A-Z)
# 			[ ${I} == "EN" ] && I="US"
# 			use linguas_${i} && unpack morphology_dict-${i}_${I}_"${MORPH_V}".zip
# 		done
# 	fi

src_prepare() {
	qt4-r2_src_prepare

	# don't install duplicated stuff and fix installation path
	sed -i \
		-e '/desktops2/d' \
		-e '/icons2/d' \
		-e '/PREFIX = /s:/usr/local:/usr:' \
		${PN}.pro || die

	# add trailing semicolon
	sed -i -e '/^Categories/s/$/;/' redist/${PN}.desktop || die
}
