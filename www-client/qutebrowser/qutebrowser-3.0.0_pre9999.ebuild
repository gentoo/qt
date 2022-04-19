# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# - review PyQt* flags, likely not all needed
# - review python deps again, and other general changes from qt5 branch
# - try and sort out tests after upstream branch is more stable and sorted out tests
#   > check if end2end ipc path length issues still exist qith Qt6
# - enforce specific qt to be used at runtime not to end up using qt6 with -qt6
# - widevine broken with qt6?
# - how safe is it to go back & forth :6 and :5 wrt chromium basedir?
#  (perhaps will need to warn about this and not default to qt6 too early)

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qutebrowser/qutebrowser.git"
	EGIT_BRANCH="qt6-v2"
else
	SRC_URI="https://github.com/qutebrowser/qutebrowser/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Keyboard-driven, vim-like browser based on Python and Qt"
HOMEPAGE="https://www.qutebrowser.org/"

LICENSE="GPL-3+"
SLOT="0"
# Can support qt5 and qt6 at same time but, to avoid pulling multiple
# webengines, don't keep a USE=qt5 which may be globally enabled.
# Default to qt6 for newer chromium and a better web experience.
IUSE="+adblock +qt6 widevine"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/importlib_resources[${PYTHON_USEDEP}]
	' 3.8)
	$(python_gen_cond_dep '
		dev-python/colorama[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP},libyaml(+)]
		dev-python/zipp[${PYTHON_USEDEP}]
		adblock? ( dev-python/adblock[${PYTHON_USEDEP}] )')
	qt6? (
		dev-qt/qtbase:6[icu]
		$(python_gen_cond_dep '
			dev-python/PyQt6[dbus,gui,multimedia,network,opengl,printsupport,qml,sql,widgets,${PYTHON_USEDEP}]
			dev-python/PyQt6_WebEngine[widgets,${PYTHON_USEDEP}]')
	)
	!qt6? (
		dev-qt/qtcore:5[icu]
		dev-qt/qtgui:5[png]
		$(python_gen_cond_dep '
			dev-python/PyQt5[dbus,declarative,gui,multimedia,network,opengl,printsupport,sql,widgets,${PYTHON_USEDEP}]
			dev-python/PyQtWebEngine[${PYTHON_USEDEP}]')
	)
	widevine? ( www-plugins/chrome-binary-plugins )"
BDEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/cheroot[${PYTHON_USEDEP}]
			dev-python/flask[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/pytest-bdd[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/pytest-qt[${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
			dev-python/pytest-xvfb[${PYTHON_USEDEP}]
			dev-python/tldextract[${PYTHON_USEDEP}]
		)')"
[[ ${PV} != *9999 ]] || BDEPEND+=" app-text/asciidoc"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if use widevine; then
		local widevine=${EPREFIX}/usr/$(get_libdir)/chromium-browser/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
		sed "/yield from _qtwebengine_settings_args/a\    yield '--widevine-path=${widevine}'" \
			-i ${PN}/config/qtargs.py || die
	fi

	# let eclass handle python
	sed -i '/setup.py/d' misc/Makefile || die

	[[ ${PV} != *9999 ]] || ${EPYTHON} scripts/asciidoc2html.py || die

	# these plugins/tests are unnecessary here and have extra dependencies
	sed -e '/pytest-benchmark/d;s/--benchmark[^ ]*//' \
		-e '/pytest-instafail/d;s/--instafail//' \
		-i pytest.ini || die
	[[ ${PV} == *9999 ]] || rm tests/unit/scripts/test_problemmatchers.py || die
	[[ ${PV} != *9999 ]] || rm tests/unit/scripts/test_run_vulture.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# end2end and other IPC tests are broken with "Name error" if
		# socket path is over 104 characters (=124 in /var/tmp/portage)
		# https://github.com/qutebrowser/qutebrowser/issues/888 (not just OSX)
		tests/end2end
		tests/unit/misc/test_ipc.py
		# tests that don't know about our newer qtwebengine
		tests/unit/browser/webengine/test_webenginedownloads.py::TestDataUrlWorkaround
		tests/unit/utils/test_version.py::TestChromiumVersion
		# may misbehave depending on installed old python versions
		tests/unit/misc/test_checkpyver.py::test_old_python
		# bug 819393
		tests/unit/commands/test_userscripts.py::test_custom_env[_POSIXUserscriptRunner]
	)
	use widevine && EPYTEST_DESELECT+=( tests/unit/config/test_qtargs.py )

	# skip benchmarks (incl. _tree), and warning tests broken by -Wdefault
	epytest -k 'not _bench and not _matches_tree and not _warning'
}

python_install_all() {
	emake -f misc/Makefile DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	rm "${ED}"/usr/share/${PN}/scripts/{mkvenv,utils}.py || die
	fperms -x /usr/share/${PN}/{scripts/cycle-inputs.js,userscripts/README.md}
	python_fix_shebang "${ED}"/usr/share/${PN}

	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "PDF display support" www-plugins/pdfjs

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that optional scripts in ${EROOT}/usr/share/${PN}/{user,}scripts"
		elog "have additional dependencies not covered by this ebuild, for example"
		elog "view_in_mpv needs media-video/mpv[lua] and net-misc/yt-dlp."
	fi

	if use qt6; then
		ewarn "USE=qt6 is enabled, be warned this is currently under heavy development"
		ewarn "and should not be expected to work well. Can follow upstream progress at:"
		ewarn "  https://github.com/qutebrowser/qutebrowser/issues/5395 [qt6 general]"
		ewarn "  https://github.com/qutebrowser/qutebrowser/tree/qt6-v2 [used branch]"
	fi
#	if use !qt6; then
#		ewarn "USE=qt6 is disabled, be warned that Qt5's WebEngine uses a rather old"
#		ewarn "chromium version. While it is relatively maintained for security, it may"
#		ewarn "cause issues on sites/features designed with a newer version in mind."
#	fi
}
