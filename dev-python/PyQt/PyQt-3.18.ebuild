# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQt/PyQt-3.17.6.ebuild,v 1.7 2009/02/20 17:49:48 jer Exp $

EAPI="2"
inherit distutils

MY_P="PyQt-x11-gpl-${PV/*_pre/snapshot-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A set of Python bindings for Qt3"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/"
SRC_URI="http://www.riverbankcomputing.com/static/Downloads/PyQt3/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc examples"

RDEPEND="x11-libs/qt:3
	>=dev-python/sip-4.8
	>=x11-libs/qscintilla-2.4[python,-qt4]"
DEPEND="${RDEPEND}
	sys-devel/libtool"

src_prepare() {
	sed -i -e "s:  check_license():# check_license():" "${S}"/configure.py
}

src_configure() {
	distutils_python_version
	addpredict ${QTDIR}/etc/settings

	local myconf="-d $(python_get_sitedir) \
			-b /usr/bin \
			-v /usr/share/sip \
			-n /usr/include \
			-o /usr/$(get_libdir) \
			-w -y qt-mt"
	use debug && myconf="${myconf} -u"

	"${python}" configure.py ${myconf} || die 'configure failed'
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	python_need_rebuild
	make DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog NEWS README THANKS
	use doc && dohtml doc/PyQt.html
	if use examples ; then
		dodir /usr/share/doc/${PF}/examples
		cp -r examples3/* "${D}"/usr/share/doc/${PF}/examples
	fi
}
