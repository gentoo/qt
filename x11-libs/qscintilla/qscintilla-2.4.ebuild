# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils toolchain-funcs multilib qt4-edge

MY_P="${PN/qs/QS}-gpl-${PV/_pre/-snapshot-}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="+qt4 +python doc examples debug"

RDEPEND="qt4? ( x11-libs/qt-gui:4 )
	!qt4? ( x11-libs/qt:3 )"
DEPEND="${RDEPEND}"
# dev-python/PyQt needs qscintilla to build and qscintilla's python bindings
# need dev-python/PyQt, bug 199543
PDEPEND="python? ( ~dev-python/qscintilla-python-${PV}[qt4=] )"

src_configure() {
	local myqmake myqtdir
	if use qt4; then
		myqmake=eqmake4
		myqtdir=Qt4
	else
		myqmake="${QTDIR}/bin/qmake"
		myqtdir=Qt3
	fi

	cd "${S}/${myqtdir}"
	sed -i \
		-e "s:DESTDIR = \$(QTDIR)/lib:DESTDIR = lib:" \
		-e "s:DESTDIR = \$\$\[QT_INSTALL_LIBS\]:DESTDIR = lib:"\
		qscintilla.pro || die "sed in qscintilla.pro failed"

	cat <<- EOF >> qscintilla.pro
	QMAKE_CFLAGS_RELEASE=${CFLAGS} -w
	QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS} -w
	QMAKE_LFLAGS_RELEASE=${LDFLAGS}
	EOF

	${myqmake} qscintilla.pro -o Makefile
	cd "${S}/designer-${myqtdir}"

	if use qt4; then
		epatch "${FILESDIR}/${PN}-2.2-qt4.patch"
	else
		epatch "${FILESDIR}/${PN}-2.2-qt.patch"

		sed -i \
			-e "s:DESTDIR = \$(QTDIR)/plugins/designer:DESTDIR = .:" \
			designer.pro || die "sed in designer.pro failed"
	fi

	cat <<- EOF >> designer.pro
	QMAKE_CFLAGS_RELEASE=${CFLAGS} -w
	QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS} -w
	QMAKE_LFLAGS_RELEASE=${LDFLAGS}
	EOF

	${myqmake} designer.pro -o Makefile
}

src_compile() {
	if use qt4; then
		cd "${S}"/Qt4
	else
		cd "${S}"/Qt3
	fi
	make all staticlib CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINK="$(tc-getCXX)" || die "make failed"

	if use qt4; then
		cd "${S}"/designer-Qt4
		make DESTDIR="${D}"/usr/lib/qt4/plugins/designer || die "make failed"
		dodir /usr/lib/qt4/plugins/designer
	else
		cd "${S}"/designer-Qt3
		make DESTDIR="${D}"/${QTDIR}/plugins/designer || die "make failed"
		dodir ${QTDIR}/plugins/designer
	fi
	make
}

src_install() {
	dodoc ChangeLog NEWS README*
	dodir /usr/{include,$(get_libdir),share/qscintilla/translations}
	if use qt4; then
		cd "${S}"/Qt4
	else
		cd "${S}"/Qt3
	fi
	cp -r Qsci "${D}/usr/include"
	#cp qextscintilla*.h "${D}/usr/include"
	cp qscintilla*.qm "${D}/usr/share/qscintilla/translations"
	cp libqscintilla2.a* "${D}/usr/$(get_libdir)"
	cp -d libqscintilla2.so.* "${D}/usr/$(get_libdir)"
	if use qt4; then
		dodir /usr/share/qt4/translations/
		for I in $(ls -1 qscintilla*.qm) ; do
			dosym "/usr/share/qscintilla/translations/${I}" "/usr/share/qt4/translations/${I}"
		done
	else
		dodir ${QTDIR}/translations/
		for I in $(ls -1 qscintilla*.qm) ; do
			dosym "/usr/share/qscintilla/translations/${I}" "${QTDIR}/translations/${I}"
		done
	fi
	if use doc ; then
		dohtml "${S}"/doc/html/*
		insinto /usr/share/doc/${PF}/Scintilla
		doins "${S}"/doc/Scintilla/*
	fi
	if use qt4; then
		insinto /usr/$(get_libdir)/qt4/plugins/designer
		insopts  -m0755
		doins "${S}"/designer-Qt4/libqscintillaplugin.so
	else
		insinto ${QTDIR}/plugins/designer
		insopts  -m0755
		doins "${S}"/designer-Qt3/libqscintillaplugin.so
	fi
}

pkg_postinst() {
	if use qt4; then
		ewarn "Please remerge dev-python/PyQt4 if you have problems with eric4"
	else
		ewarn "Please remerge dev-python/PyQt if you have problems with eric3"
	fi
	ewarn "or other qscintilla related packages before submitting bug reports."
}
