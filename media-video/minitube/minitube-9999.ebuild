# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/minitube/minitube-1.1.ebuild,v 1.3 2010/08/09 14:34:22 hwoarang Exp $

EAPI="4"

LANGS="ca da es es_AR es_ES el fr gl hr hu ia id it nb nl pl pt pt_BR ro
ru sl sq sr sv_SE te tr zh_CN"
LANGSLONG="ca_ES de_DE fi_FI he_IL id_ID ka_GE pl_PL uk_UA"

EGIT_REPO_URI="git://gitorious.org/minitube/minitube.git"
inherit qt4-r2 git-2

DESCRIPTION="Qt4 YouTube Client"
HOMEPAGE="http://flavio.tordini.org/minitube"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug kde gstreamer"

DEPEND="x11-libs/qt-gui:4[accessibility]
	x11-libs/qt-dbus:4
	gstreamer? (
		kde? ( || ( media-libs/phonon[gstreamer]  x11-libs/qt-phonon:4 ) )
		!kde? ( || ( x11-libs/qt-phonon media-libs/phonon[gstreamer] ) )
		media-plugins/gst-plugins-soup
		media-plugins/gst-plugins-ffmpeg
		media-plugins/gst-plugins-faac
		media-plugins/gst-plugins-faad )
	!gstreamer? ( media-libs/phonon[-gstreamer] )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	eqmake4 ${PN}.pro PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	newicon images/app.png minitube.png
	#translations
	insinto "/usr/share/${PN}/locale/"
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
				rm "${D}"/usr/share/${PN}/locale/${x}.qm || die
		fi
	done
	for x in ${LANGSLONG}; do
		if ! has ${x%_*} ${LINGUAS}; then
			rm "${D}"/usr/share/${PN}/locale/${x}.qm || die
		fi
	done
}
