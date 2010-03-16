# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qscintilla/qscintilla-2.4.2-r1.ebuild,v 1.1 2010/02/01 17:44:20 hwoarang Exp $

EAPI="2"

inherit qt4-r2

REVISION="111da2e01c5e"
MY_P="QScintilla-gpl-snapshot-${PV/_pre*/}-${REVISION}"

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc python"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"
PDEPEND="python? ( ~dev-python/qscintilla-python-${PV} )"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${PN}-2.4-designer.patch" )

src_configure() {
	cd "${S}"/Qt4
	einfo "Configuring qscintilla"
	eqmake4 qscintilla.pro

	cd "${S}"/designer-Qt4
	einfo "Configuring designer plugin"
	eqmake4 designer.pro
}

src_compile() {
	cd "${S}"/Qt4
	einfo "Building qscintilla"
	emake || die "failed to build qscintilla"

	cd "${S}"/designer-Qt4
	einfo "Building designer plugin"
	emake || die "failed to build designer plugin"
}

src_install() {
	cd "${S}"/Qt4
	einfo "Installing qscintilla"
	emake INSTALL_ROOT="${D}" install || die "failed to install qscintilla"

	cd "${S}"/designer-Qt4
	einfo "Installing designer plugin"
	emake INSTALL_ROOT="${D}" install || die "failed to install designer plugin"

	cd "${S}"
	dodoc ChangeLog NEWS
	if use doc; then
		einfo "Installing documentation"
		dohtml doc/html-Qt4/* || die
		insinto /usr/share/doc/${PF}/Scintilla
		doins doc/Scintilla/* || die
	fi
}
