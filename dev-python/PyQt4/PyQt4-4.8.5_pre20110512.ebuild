# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython"

inherit python qt4-r2 toolchain-funcs

REVISION=4b711e1aa672
MY_P="PyQt-x11-gpl-snapshot-${PV/_pre*/}-${REVISION}"
QT_VER="4.7.1" # minimal Qt version this is supposed to work with

DESCRIPTION="Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/ http://pypi.python.org/pypi/PyQt"
#SRC_URI="http://www.riverbankcomputing.com/static/Downloads/${PN}/${MY_P}.tar.gz"

SRC_URI="http://www.gentoo-el.org/~hwoarang/distfiles/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="X assistant +dbus debug declarative examples kde multimedia opengl phonon sql svg webkit xmlpatterns"

DEPEND=">=dev-python/sip-4.11.2
	>=x11-libs/qt-core-${QT_VER}:4
	>=x11-libs/qt-script-${QT_VER}:4
	>=x11-libs/qt-test-${QT_VER}:4
	X? ( >=x11-libs/qt-gui-${QT_VER}:4[dbus?] )
	assistant? ( >=x11-libs/qt-assistant-${QT_VER}:4 )
	dbus? (
		>=dev-python/dbus-python-0.80
		>=x11-libs/qt-dbus-${QT_VER}:4
	)
	declarative? ( >=x11-libs/qt-declarative-${QT_VER}:4 )
	multimedia? ( >=x11-libs/qt-multimedia-${QT_VER}:4 )
	opengl? ( >=x11-libs/qt-opengl-${QT_VER}:4 || ( >=x11-libs/qt-opengl-4.7.0:4[-egl] <x11-libs/qt-opengl-4.7.0:4 ) )
	phonon? (
		!kde? ( || ( >=x11-libs/qt-phonon-${QT_VER}:4 media-libs/phonon ) )
		kde? ( media-libs/phonon )
	)
	sql? ( >=x11-libs/qt-sql-${QT_VER}:4 )
	svg? ( >=x11-libs/qt-svg-${QT_VER}:4 )
	webkit? ( >=x11-libs/qt-webkit-${QT_VER}:4 )
	xmlpatterns? ( >=x11-libs/qt-xmlpatterns-${QT_VER}:4 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-4.7.2-configure.py.patch"
)

src_prepare() {
	if ! use dbus; then
		sed -e "s/^\([[:blank:]]\+\)check_dbus()/\1pass/" -i configure.py || die "sed configure.py failed"
	fi

	# Support qreal for arm architecture (bug #322349).
	use arm && epatch "${FILESDIR}/${PN}-4.7.3-qreal_float_support.patch"

	qt4-r2_src_prepare

	# Use proper include directory.
	sed -e "s:/usr/include:${EPREFIX}/usr/include:g" -i configure.py || die "sed configure.py failed"

	python_copy_sources

	preparation() {
		if [[ "$(python_get_version --major)" == "3" ]]; then
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
		local myconf=("$(PYTHON)"
			configure.py
			--confirm-license
			--bindir="${EPREFIX}/usr/bin"
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			--qsci-api
			$(use debug && echo --debug)
			--enable=QtCore
			--enable=QtNetwork
			--enable=QtScript
			--enable=QtTest
			--enable=QtXml
			$(pyqt4_use_enable X QtGui)
			$(pyqt4_use_enable X QtDesigner)
			$(pyqt4_use_enable X QtScriptTools)
			# QtAssistant module is not available with Qt >=4.7.0.
			$(pyqt4_use_enable assistant QtAssistant)
			$(pyqt4_use_enable assistant QtHelp)
			$(pyqt4_use_enable declarative QtDeclarative)
			$(pyqt4_use_enable multimedia QtMultimedia)
			$(pyqt4_use_enable opengl QtOpenGL)
			$(pyqt4_use_enable phonon)
			$(pyqt4_use_enable sql QtSql)
			$(pyqt4_use_enable svg QtSvg)
			$(pyqt4_use_enable webkit QtWebKit)
			$(pyqt4_use_enable xmlpatterns QtXmlPatterns)
			CC="$(tc-getCC)"
			CXX="$(tc-getCXX)"
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			CFLAGS="${CFLAGS}"
			CXXFLAGS="${CXXFLAGS}"
			LFLAGS="${LDFLAGS}")
		echo "${myconf[@]}"
		"${myconf[@]}" || return 1

		local mod
		for mod in QtCore $(use X && echo QtDesigner QtGui) $(use declarative &&
		echo QtDeclarative); do
			# Run eqmake4 inside the qpy subdirectories to avoid stripping and many other QA issues.
			pushd qpy/${mod} > /dev/null || return 1
			eqmake4 $(ls w_qpy*.pro)
			popd > /dev/null || return 1

			# Fix insecure runpaths.
			sed -e "/^LFLAGS/s:-Wl,-rpath,${BUILDDIR}/qpy/${mod}::" -i ${mod}/Makefile || die "Fixing of rpaths failed"
		done

		# Fix pre-stripping of libpythonplugin.so
		if use X; then
			cd "${BUILDDIR}/designer"
			eqmake4 python.pro
		fi
	}
	python_execute_function -s configuration
}

src_compile() {
	python_src_compile
}

src_install() {
	installation() {
		# INSTALL_ROOT is needed for the QtDesigner module, other Makefiles use DESTDIR.
		emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	}
	python_execute_function -s installation

	dodoc NEWS README THANKS || die "dodoc failed"

	if use doc; then
		dohtml -r doc/* || die "dohtml failed"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "doins failed"
	fi
}

pkg_postinst() {
	python_mod_optimize PyQt4
}

pkg_postrm() {
	python_mod_cleanup PyQt4
}
