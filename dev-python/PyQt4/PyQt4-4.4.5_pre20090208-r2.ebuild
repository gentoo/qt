# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils qt4-edge

MY_PV=${PV/_pre/-snapshot-}
MY_P=PyQt-x11-gpl-${MY_PV}

DESCRIPTION="A set of Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/"
# SRC_URI="http://www.riverbankcomputing.com/static/Downloads/${PN}/${MY_P}.tar.gz"
# upstream drops the tarball as soon as they have a new snapshot out
SRC_URI="http://dl.liveforge.org/distfiles/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="X assistant dbus debug doc examples opengl phonon qt3support sql svg webkit xmlpatterns"

RDEPEND=">=dev-python/sip-4.7.8
	>=x11-libs/qt-core-4.4.2:4[qt3support?]
	>=x11-libs/qt-script-4.4.2:4
	>=x11-libs/qt-test-4.4.2:4
	X? ( >=x11-libs/qt-gui-4.4.2:4[dbus?,qt3support?] )
	assistant? ( >=x11-libs/qt-assistant-4.4.2:4 )
	dbus? (
		dev-python/dbus-python
		>=x11-libs/qt-dbus-4.4.2:4
	)
	opengl? ( >=x11-libs/qt-opengl-4.4.2:4[qt3support?] )
	phonon? ( || ( >=x11-libs/qt-phonon-4.4.2:4 media-sound/phonon ) )
	qt3support? ( >=x11-libs/qt-qt3support-4.4.2:4 )
	sql? ( >=x11-libs/qt-sql-4.4.2:4 )
	svg? ( >=x11-libs/qt-svg-4.4.2:4 )
	webkit? ( >=x11-libs/qt-webkit-4.4.2:4 )
	xmlpatterns? ( >=x11-libs/qt-xmlpatterns-4.4.2:4 )"
DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/configure.py.patch"
	"${FILESDIR}/fix_license_check.patch"
)

pyqt4_use_enable() {
	use $1 && echo "--enable=${2:-$1}"
}

src_prepare() {
	if ! use dbus; then
		sed -i -e 's,^\([[:blank:]]\+\)check_dbus(),\1pass,' \
			"${S}"/configure.py || die
	fi
	qt4-edge_src_prepare
}

src_configure() {
	distutils_python_version

	local myconf="--confirm-license
			--bindir=/usr/bin
			--destdir=/usr/$(get_libdir)/python${PYVER}/site-packages
			--sipdir=/usr/share/sip
			$(use debug && echo '--debug')
			--enable=QtCore
			--enable=QtNetwork
			--enable=QtScript
			--enable=QtTest
			--enable=QtXml
			$(pyqt4_use_enable X QtGui)
			$(pyqt4_use_enable X QtDesigner)
			$(pyqt4_use_enable assistant QtAssistant)
			$(pyqt4_use_enable assistant QtHelp)
			$(pyqt4_use_enable opengl QtOpenGL)
			$(pyqt4_use_enable phonon)
			$(pyqt4_use_enable sql QtSql)
			$(pyqt4_use_enable svg QtSvg)
			$(pyqt4_use_enable webkit QtWebKit)
			$(pyqt4_use_enable xmlpatterns QtXmlPatterns)"
	echo "${python}" configure.py ${myconf}
	"${python}" configure.py ${myconf} || die "configuration failed"
}

src_install() {
	# INSTALL_ROOT is needed for the QtDesigner module,
	# the other Makefiles use DESTDIR.
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install || die "installation failed"

	dodoc ChangeLog NEWS THANKS || die

	if use doc; then
		dohtml -r doc/html/* || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
