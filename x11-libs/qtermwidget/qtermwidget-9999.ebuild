# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qtermwidget/qtermwidget-9999.ebuild,v 1.2 2014/09/13 16:36:24 kensington Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_3 )

inherit cmake-utils git-r3 python-r1

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/qterminal/"
EGIT_REPO_URI="git://github.com/qterminal/qtermwidget.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug python qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="qt4? ( dev-qt/qtcore:4
               dev-qt/qtgui:4 )
        qt5? ( dev-qt/qtcore:5
               dev-qt/qtgui:5 )"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e 's/int scheme/const QString \&name/' \
		-i pyqt4/qtermwidget.sip || die "sed qtermwidget.sip failed"
}

src_configure() {
        local mycmakeargs=(
            $(cmake-utils_use_use qt5 QT5)
            $(cmake-utils_use_build qt4 DESIGNER_PLUGIN)
        )
        cmake-utils_src_configure
# cmake-utils.eclass exports BUILD_DIR only after configure phase, so sed it here
	sed \
		-e "/extra_lib_dirs/s@\.\.@${BUILD_DIR}@" \
		-e '/extra_libs/s/qtermwidget/qtermwidget4/' \
		-i pyqt4/config.py || die "sed config.py failed"
	if use python; then
		configuration() {
			${PYTHON} config.py || die "${PYTHON} config.py failed"
		}
		BUILD_DIR="${S}/pyqt4" python_copy_sources
		BUILD_DIR="${S}/pyqt4" python_parallel_foreach_impl run_in_build_dir configuration || die "python configuration failed"
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use python; then
		BUILD_DIR="${S}/pyqt4" python_parallel_foreach_impl run_in_build_dir emake
	fi
}

src_install() {
	cmake-utils_src_install

	if use python; then
		BUILD_DIR="${S}/pyqt4" python_parallel_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
		BUILD_DIR="${S}/pyqt4" python_parallel_foreach_impl python_optimize
	fi
}

