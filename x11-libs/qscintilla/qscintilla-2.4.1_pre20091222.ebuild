# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qscintilla/qscintilla-2.4.ebuild,v 1.1 2009/06/09 19:00:02 hwoarang Exp $

EAPI="2"

inherit eutils multilib qt3 qt4

MY_P="QScintilla-gpl-${PV/_pre/-snapshot-}"

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc python"

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"
PDEPEND="python? ( ~dev-python/qscintilla-python-${PV} )"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}/${PN}-2.4-designer.patch" )

src_configure() {
	myqtver=4
	myqtdir=/usr/share/qt4

	cd "${S}"/Qt${myqtver}
	eqmake${myqtver} qscintilla.pro

	cd "${S}"/designer-Qt${myqtver}
	eqmake${myqtver} designer.pro
}

src_compile() {
	cd "${S}"/Qt${myqtver}
	emake all staticlib || die "emake failed"

	cd "${S}"/designer-Qt${myqtver}
	emake || die "failed to build designer plugin"
}

src_install() {
	cd "${S}"/Qt${myqtver}
	# header files
	insinto /usr/include/Qsci
	doins Qsci/*.h || die
	# libraries
	dolib.so libqscintilla2.so* || die
	dolib.a libqscintilla2.a || die
	# translations
	insinto /usr/share/${PN}/translations
	doins qscintilla_*.qm || die
	for trans in $(ls -1 qscintilla_*.qm); do
		dosym /usr/share/${PN}/translations/${trans} \
			${myqtdir}/translations/${trans} || die
	done

	# designer plugin
	cd "${S}"/designer-Qt${myqtver}
	emake INSTALL_ROOT="${D}" install || die "designer plugin installation failed"

	# documentation
	cd "${S}"
	dodoc ChangeLog NEWS
	if use doc; then
		dohtml doc/html-Qt${myqtver}/* || die
		insinto /usr/share/doc/${PF}/Scintilla
		doins doc/Scintilla/* || die
	fi
}

pkg_postinst() {
	if use qt4; then
		ewarn "Please remerge dev-python/PyQt4 if you have problems with eric or other"
	else
		ewarn "Please remerge dev-python/PyQt if you have problems with"
	fi
	ewarn "qscintilla related packages before submitting bug reports."
}
