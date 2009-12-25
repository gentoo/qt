# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="de_DE es_ES fi_FI fr_FR gl_ES hu_HU it_IT ja_JP nb_NO nl_NL pl_PL ru_RU tr_TR uk_UA zh_CN"
inherit qt4-edge subversion

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions."
HOMEPAGE="http://keepassx.sourceforge.net/"
ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug pch"

DEPEND="x11-libs/qt-core:4[qt3support]
	x11-libs/qt-gui:4[qt3support]
	x11-libs/qt-xmlpatterns:4"
RDEPEND="${DEPEND}"

src_prepare() {
	subversion_src_prepare

	# build system installs all translation, so delete unneeded ones
	local i18npath="${S}/share/${PN}/i18n"
	for X in ${LANGS}; do
		if ! use linguas_${X%_*}; then
			rm "${i18npath}/${PN}-${X}.qm"
			[ -e "${i18npath}/qt_${X%_*}.qm" ] && rm "${i18npath}/qt_${X%_*}.qm"
		fi
	done

	rmdir "${S}/share/${PN}/i18n/" 2>/dev/null && \
		sed -i "/INSTALL.*i18n/d" "${S}/src/CMakeLists.txt"
}

src_configure() {
	local conf_pch
	use pch && conf_pch="PRECOMPILED=1" || conf_pch="PRECOMPILED=0"

	eqmake4 ${PN}.pro -recursive \
		PREFIX="${D}/usr" \
		"${conf_pch}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc changelog || die "dodoc failed"
}
