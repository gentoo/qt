# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python distutils eutils

DESCRIPTION="Qt4 relational algebra application"
HOMEPAGE="http://qt-apps.org/content/show.php/Relational?content=86178"
# upstream url is not static
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-python/PyQt4[webkit,X]
	media-fonts/dejavu"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	true
}

src_install() {
	insinto "$(python_get_sitedir)/"
	doins -r "${PN}_gui" || die "doins failed"
	doins -r "${PN}" || die "doins failed"
	newbin ${PN}_gui.py ${PN} || die "dobin failed"
	domenu ${PN}.desktop || die "domenu failed"
	dodoc CHANGELOG CREDITS README || die "dodoc failed"
	doman ${PN}.1 || die "doman failed"
}

pkg_postinst() {
	python_version
	python_mod_optimize $(python_get_sitedir)/${PN}/
	python_mod_optimize $(python_get_sitedir)/${PN}_gui/
}

pkg_postrm() {
	python_mod_cleanup
}
