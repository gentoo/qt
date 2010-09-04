# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit python

MY_P="${PN}-gpl-${PV}"

DESCRIPTION="Python bindings for Nokia's QtMobility libraries"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqtmobility/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64"

PYQTM_MODULES="bearer contacts +location messaging multimedia +publishsubscribe sensors +serviceframework systeminfo versit"
IUSE="debug ${PYQTM_MODULES}"

QTM_USE_DEPS=
for mod in ${PYQTM_MODULES//+}; do
	QTM_USE_DEPS+="${mod}?,"
done
unset mod

DEPEND=">=dev-python/sip-4.11
	>=dev-python/PyQt4-4.7.5[X]
	>=x11-libs/qt-mobility-1.0.2[${QTM_USE_DEPS%,}]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_pkg_setup

	# figure out which modules to build
	local modules=( $(pyqtm_use_enable bearer)
			$(pyqtm_use_enable contacts)
			$(pyqtm_use_enable location)
			$(pyqtm_use_enable messaging)
			$(pyqtm_use_enable multimedia QtMultimediaKit)
			$(pyqtm_use_enable publishsubscribe QtPublishSubscribe)
			$(pyqtm_use_enable sensors)
			$(pyqtm_use_enable serviceframework QtServiceFramework)
			$(pyqtm_use_enable systeminfo QtSystemInfo)
			$(pyqtm_use_enable versit) )
	if [[ ${#modules[@]} -eq 0 ]]; then
		ewarn "At least one module must be selected for building, but you have selected none."
		ewarn "The QtLocation module will be automatically enabled."
		myconf="--enable=QtLocation"
	else
		myconf="${modules[@]}"
	fi
}

src_prepare() {
	# disable stripping of modules
	sed -i -e '/SIPModuleMakefile/s|$|strip=0,|' configure.py || die

	python_src_prepare
}

src_configure() {
	configuration() {
		set -- $(PYTHON) configure.py \
			--destdir="${EPREFIX}"$(python_get_sitedir) \
			--sipdir="${EPREFIX}"/usr/share/sip \
			$(use debug && echo --debug) \
			${myconf}
		echo "$@"
		"$@" || die "configure.py failed"
	}
	python_execute_function -s configuration
}

pkg_postinst() {
	python_mod_optimize QtMobility
}

pkg_postrm() {
	python_mod_cleanup QtMobility
}

pyqtm_use_enable() {
	use $1 && echo --enable=${2:-Qt$(echo ${1:0:1} | tr '[:lower:]' '[:upper:]')${1:1}}
}
