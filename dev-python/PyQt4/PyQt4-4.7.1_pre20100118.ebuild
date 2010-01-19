# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQt4/PyQt4-4.7.ebuild,v 1.1 2010/01/15 15:15:44 yngwin Exp $

EAPI="2"
PYTHON_DEFINE_DEFAULT_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit qt4-r2 python toolchain-funcs

MY_P="PyQt-x11-gpl-${PV/_pre/-snapshot-}"
QTVER="4.5.3" # minimal Qt version this is supposed to work with

DESCRIPTION="A set of Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/ http://pypi.python.org/pypi/PyQt"
SRC_URI="http://www.riverbankcomputing.com/static/Downloads/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="X assistant +dbus debug doc examples kde multimedia opengl phonon sql svg webkit xmlpatterns"

DEPEND="=dev-python/sip-4.10*
	>=x11-libs/qt-core-${QTVER}:4
	>=x11-libs/qt-script-${QTVER}:4
	>=x11-libs/qt-test-${QTVER}:4
	X? ( >=x11-libs/qt-gui-${QTVER}:4[dbus?] )
	assistant? ( >=x11-libs/qt-assistant-${QTVER}:4 )
	dbus? (
		>=dev-python/dbus-python-0.80
		>=x11-libs/qt-dbus-${QTVER}:4
	)
	multimedia? ( >=x11-libs/qt-multimedia-${QTVER}:4 )
	opengl? ( >=x11-libs/qt-opengl-${QTVER}:4 )
	phonon? (
		!kde? ( || ( >=x11-libs/qt-phonon-${QTVER}:4 media-sound/phonon ) )
		kde? ( media-sound/phonon )
	)
	sql? ( >=x11-libs/qt-sql-${QTVER}:4 )
	svg? ( >=x11-libs/qt-svg-${QTVER}:4 )
	webkit? ( >=x11-libs/qt-webkit-${QTVER}:4 )
	xmlpatterns? ( >=x11-libs/qt-xmlpatterns-${QTVER}:4 )"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.2" # doesn't build with python:3.2 (yet), bug 292419

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/configure-4.6.1.py.patch"
	"${FILESDIR}/${PN}-4.6.1-configure-multilib.patch"
)

src_prepare() {
	if ! use dbus; then
		sed -i -e 's,^\([[:blank:]]\+\)check_dbus(),\1pass,' \
			"${S}"/configure.py || die
	fi

	qt4-r2_src_prepare
	python_copy_sources

	preparation() {
		if [[ "${PYTHON_ABI:0:1}" == "3" ]]; then
			rm -fr pyuic/uic/port_v2
		else
			rm -fr pyuic/uic/port_v3
		fi
	}
	python_execute_function -s preparation
}

pyqt4_use_enable() {
	use $1 && echo "--enable=${2:-$1}"
}

src_configure() {
	configuration() {
		local myconf="$(PYTHON) configure.py
				--confirm-license
				--bindir=/usr/bin
				--destdir=$(python_get_sitedir)
				--sipdir=/usr/share/sip
				--qsci-api
				$(use debug && echo '--debug')
				--enable=QtCore
				--enable=QtNetwork
				--enable=QtScript
				--enable=QtTest
				--enable=QtXml
				$(pyqt4_use_enable X QtGui)
				$(pyqt4_use_enable X QtDesigner)
				$(pyqt4_use_enable X QtScriptTools)
				$(pyqt4_use_enable assistant QtAssistant)
				$(pyqt4_use_enable assistant QtHelp)
				$(pyqt4_use_enable multimedia QtMultimedia)
				$(pyqt4_use_enable opengl QtOpenGL)
				$(pyqt4_use_enable phonon)
				$(pyqt4_use_enable sql QtSql)
				$(pyqt4_use_enable svg QtSvg)
				$(pyqt4_use_enable webkit QtWebKit)
				$(pyqt4_use_enable xmlpatterns QtXmlPatterns)
				CC=$(tc-getCC) CXX=$(tc-getCXX)
				LINK=$(tc-getCXX) LINK_SHLIB=$(tc-getCXX)
				CFLAGS='${CFLAGS}' CXXFLAGS='${CXXFLAGS}' LFLAGS='${LDFLAGS}'"
		echo ${myconf}
		eval ${myconf} || return 1

		for mod in QtCore $(use X && echo 'QtDesigner QtGui'); do
			# Run eqmake4 inside the qpy subdirs to prevent
			# stripping and many other QA issues
			pushd qpy/${mod} > /dev/null || die
			eqmake4 $(ls w_qpy*.pro)
			popd > /dev/null || die

			# Fix insecure runpaths
			sed -i -e "/^LFLAGS/s:-Wl,-rpath,${BUILDDIR}/qpy/${mod}::" \
				${mod}/Makefile || die "failed to fix rpath issues"
		done

		# Fix pre-stripping of libpythonplugin.so
		if use X; then
			cd "${BUILDDIR}"/designer
			eqmake4 python.pro
		fi
	}
	python_execute_function -s configuration
}

src_compile() {
	python_execute_function -d -s
}

src_install() {
	installation() {
		# INSTALL_ROOT is needed for the QtDesigner module,
		# the other Makefiles use DESTDIR.
		emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	}
	python_execute_function -s installation

	dodoc ChangeLog doc/pyqt4ref.txt NEWS THANKS || die

	if use doc; then
		dohtml -r doc/* || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}

pkg_postinst() {
	python_mod_optimize PyQt4
}

pkg_postrm() {
	python_mod_cleanup PyQt4
}
