# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_MAX_SLOT=16
PLOCALES="cs da de fr hr ja pl ru sl uk zh-CN zh-TW"

inherit cmake llvm optfeature virtualx xdg

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://doc.qt.io/qtcreator/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.qt.io/${PN}/${PN}.git"
	EGIT_SUBMODULES=(
		perfparser
		qtscript # Need the dev branch
		src/libs/qlitehtml
		src/libs/qlitehtml/src/3rdparty/litehtml
	)
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-opensource-src-${MY_PV}
	[[ ${MY_PV} == ${PV} ]] && MY_REL=official || MY_REL=development
	SRC_URI="https://download.qt.io/${MY_REL}_releases/${PN/-}/$(ver_cut 1-2)/${MY_PV}/${MY_P}.tar.xz"
	S="${WORKDIR}"/${MY_P}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

QTCREATOR_PLUGINS=(
	# Misc
	+autotest beautifier coco conan cppcheck ctfvisualizer +designer docker
	+help imageviewer modeling perfprofiler qmlprofiler scxml serialterminal
	silversearcher squish valgrind

	# Buildsystems
	autotools +cmake incredibuild meson qbs +qmake

	# Languages
	glsl +lsp nim python

	# Platforms
	android baremetal boot2qt mcu qnx remotelinux webassembly

	# VCS
	bazaar clearcase cvs +git mercurial perforce subversion
)

IUSE="+clang debug doc +qml systemd test wayland webengine
	${QTCREATOR_PLUGINS[@]}"

REQUIRED_USE="
	android? ( lsp )
	boot2qt? ( remotelinux )
	clang? ( lsp )
	coco? ( lsp )
	mcu? ( baremetal cmake )
	python? ( lsp )
	qml? ( qmake )
	qnx? ( remotelinux )
	test? ( qbs qmake )
"

# minimum Qt version required
QT_PV="6.2.0:6"

BDEPEND="
	>=dev-qt/qttools-${QT_PV}[linguist(+)]
	doc? ( >=dev-qt/qttools-${QT_PV}[qdoc(+)] )
"
CDEPEND="
	clang? (
		>=dev-cpp/yaml-cpp-0.6.2:=
		|| (
			sys-devel/clang:16
			sys-devel/clang:15
			sys-devel/clang:14
		)
		<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
	)
	>=dev-qt/qt5compat-${QT_PV}
	>=dev-qt/qtbase-${QT_PV}[concurrent,gui,network,sql,widgets]
	>=dev-qt/qtdeclarative-${QT_PV}

	designer? ( >=dev-qt/qttools-${QT_PV}[designer(+)] )
	help? (
		>=dev-qt/qttools-${QT_PV}[assistant(+)]
		webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets] )
		!webengine? ( dev-libs/gumbo )
	)
	imageviewer? ( >=dev-qt/qtsvg-${QT_PV} )
	perfprofiler? (
		app-arch/zstd
		dev-libs/elfutils
	)
	qml? (
		>=dev-qt/qtshadertools-${QT_PV}
		>=dev-qt/qtquick3d-${QT_PV}
	)
	serialterminal? ( >=dev-qt/qtserialport-${QT_PV} )
	systemd? ( sys-apps/systemd:= )
	test? ( mcu? ( dev-cpp/gtest:= ) )
"
DEPEND="
	${CDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/eigen
		dev-cpp/gtest
		dev-libs/boost
		>=dev-qt/qtbase-${QT_PV}[test]
	)
"
RDEPEND="
	${CDEPEND}
	qml? ( >=dev-qt/qtquicktimeline-${QT_PV} )
	wayland? ( >=dev-qt/qtbase-${QT_PV}[egl] )
"

# qt translations must also be installed or qt-creator translations won't be loaded
for x in ${PLOCALES}; do
	IUSE+=" l10n_${x}"
	RDEPEND+=" l10n_${x}? ( >=dev-qt/qttranslations-${QT_PV} )"
done
unset x

# FUNCTION: cmake_use_remove_addsubdirectory
# USAGE: <flag> <subdir> <files...>
# DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <subdir> is the  name of a directory called with add_subdirectory().
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to remove add_subdirectory(<subdir>) from cmake
# when <flag> is disabled, otherwise it does nothing. This can be useful to
# avoid an automagic dependency when a subdirectory is added in cmake but the
# corresponding feature USE flag is disabled. Similar to qt_use_disable_config()
# from /qt5-build.eclass
cmake_use_remove_addsubdirectory() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least three arguments"
	local flag=$1
	local subdir=$2
	shift 2

	if ! use "${flag}"; then
		echo "$@" | xargs sed -i -e "/add_subdirectory(${subdir})/d" || die
	fi
}

llvm_check_deps() {
	has_version -d "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	if use clang; then
		llvm_pkg_setup
		export CLANG_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
	fi
}

src_prepare() {
	cmake_src_prepare

	# PLUGIN_RECOMMENDS is treated like a hard-dependency
	sed -i -e '/PLUGIN_RECOMMENDS /d' \
		src/plugins/*/CMakeLists.txt || die

	# fix translations
	local languages=()
	for lang in ${PLOCALES}; do
		use l10n_${lang} && languages+=( "${lang/-/_}" )
	done
	sed -i -e "s|^set(languages.*|set(languages ${languages[*]})|" \
		share/qtcreator/translations/CMakeLists.txt || die

	# misc automagic
	cmake_use_remove_addsubdirectory clang clangcodemodel \
		src/plugins/CMakeLists.txt
	cmake_use_remove_addsubdirectory clang clangformat \
		src/plugins/CMakeLists.txt
	cmake_use_remove_addsubdirectory clang clangtools \
		src/plugins/CMakeLists.txt
	cmake_use_remove_addsubdirectory glsl glsl src/libs/CMakeLists.txt
	cmake_use_remove_addsubdirectory lsp languageserverprotocol \
		src/libs/CMakeLists.txt tests/auto/CMakeLists.txt
	cmake_use_remove_addsubdirectory modeling modelinglib \
		src/libs/CMakeLists.txt
	cmake_use_remove_addsubdirectory qml advanceddockingsystem \
		src/libs/CMakeLists.txt
	cmake_use_remove_addsubdirectory test test \
		src/plugins/mcusupport/CMakeLists.txt

	# remove bundled yaml-cpp
	rm -r src/libs/3rdparty/yaml-cpp || die

	# remove bundled qbs
	rm -r src/shared/qbs || die

	# qt-creator hardcodes the CLANG_INCLUDE_DIR to the default.
	# However, in sys-devel/clang, the directory changes with respect to
	# -DCLANG_RESOURCE_DIR.  We sed in the correct include dir.
	if use clang; then
		local res_dir="$(${CLANG_PREFIX}/bin/clang -print-resource-dir || die)"
		sed -i -e "/\w*CLANG_INCLUDE_DIR=/s|=.*|=\"${res_dir}/include\"|" \
			src/plugins/clangtools/CMakeLists.txt || die
	fi

	if use doc; then
		# Fix doc install path
		sed -i -e "/set(_IDE_DOC_PATH/s|qtcreator|${PF}|" \
			cmake/QtCreatorAPIInternal.cmake || die
	fi

	if use help && ! use webengine; then
		# unbundled gumbo doesn't use cmake
		local gumbo_dep='find_package(PkgConfig REQUIRED)\n'
		gumbo_dep+='pkg_check_modules(gumbo REQUIRED IMPORTED_TARGET gumbo)\n'
		sed -i -e '/^\s*gumbo/s|gumbo|PkgConfig::gumbo|' \
			-e "/^find_package(litehtml/s|^|${gumbo_dep}|" \
			src/libs/qlitehtml/src/CMakeLists.txt || die
	fi

	# QT Design Studio related. Default-disabled for now.
	#
	# # Use QmlDom from system's qtdeclarative instead of auto-downloading and building
	# if use qml; then
	# 	local PAT_REP='/\sget_and_add_as_subdirectory(/,/LIBRARY_OUTPUT_DIRECTORY>\")$/'
	# 	sed -i -e "${PAT_REP}c\find_package(Qt5 COMPONENTS QmlDomPrivate REQUIRED)" \
	# 		-e 's|qmldomlib|Qt6\:\:QmlDomPrivate|g' \
	# 		src/plugins/qmldesigner/CMakeLists.txt || die
	# fi

	if use test; then
		# Find "GoogleBenchmark" as "benchmark" and change bundled "Googletest"
		# to external "GTest"
		find "${S}" -type f -name CMakeLists.txt -exec \
			xargs sed -i -e 's|TARGET GoogleBenchmark|benchmark_FOUND|g' \
				-e 's|GoogleBenchmark\( MODULE\)\?|benchmark|g' \
				-e 's|Googletest\( MODULE\)\?|GTest|g' {} \; || die
		# For mcu, also link to gmock to prevent an unknown symbol
		# error at runtime.
		sed -i -e  's|if(TARGET GTest)|if(GTest_FOUND)|' \
			-e 's|DEPENDS GTest|DEPENDS gtest gmock|' \
			src/plugins/mcusupport/test/CMakeLists.txt || die
	fi
}

src_configure() {
	mycmakeargs+=(
		-DWITH_TESTS=$(usex test)
		-DWITH_DEBUG_CMAKE=$(usex debug)

		# Don't use SANITIZE_FLAGS to pass extra CXXFLAGS
		-DWITH_SANITIZE=NO

		# Can only use bundled version until plasma-6 release
		-DBUILD_LIBRARY_KSYNTAXHIGHLIGHTING=YES

		-DWITH_DOCS=$(usex doc)
		-DBUILD_DEVELOPER_DOCS=$(usex doc)

		# Install failure.  Disable for now
		-DWITH_ONLINE_DOCS=NO

		# Misc
		-DBUILD_PLUGIN_AUTOTEST=$(usex autotest)
		-DBUILD_PLUGIN_BEAUTIFIER=$(usex beautifier)
		-DBUILD_PLUGIN_COCO=$(usex coco)
		-DBUILD_PLUGIN_CONAN=$(usex conan)
		-DBUILD_PLUGIN_CPPCHECK=$(usex cppcheck)
		-DBUILD_PLUGIN_CTFVISUALIZER=$(usex ctfvisualizer)
		-DBUILD_PLUGIN_DESIGNER=$(usex designer)
		-DBUILD_PLUGIN_DOCKER=$(usex docker)
		-DBUILD_PLUGIN_HELP=$(usex help)
		-DBUILD_PLUGIN_IMAGEVIEWER=$(usex imageviewer)
		-DBUILD_PLUGIN_MODELEDITOR=$(usex modeling)
		-DBUILD_PLUGIN_PERFPROFILER=$(usex perfprofiler)
		-DBUILD_PLUGIN_QMLPROFILER=$(usex qmlprofiler)
		-DBUILD_PLUGIN_SCXMLEDITOR=$(usex scxml)
		-DBUILD_PLUGIN_SERIALTERMINAL=$(usex serialterminal)
		-DBUILD_PLUGIN_SILVERSEARCHER=$(usex silversearcher)
		-DBUILD_PLUGIN_SQUISH=$(usex squish)
		-DBUILD_PLUGIN_VALGRIND=$(usex valgrind)

		# Buildsystems
		-DBUILD_PLUGIN_AUTOTOOLSPROJECTMANAGER=$(usex autotools)
		-DBUILD_PLUGIN_CMAKEPROJECTMANAGER=$(usex cmake)
		-DBUILD_PLUGIN_MESONPROJECTMANAGER=$(usex meson)
		-DBUILD_PLUGIN_QBSPROJECTMANAGER=$(usex qbs)
		-DBUILD_PLUGIN_QMAKEPROJECTMANAGER=$(usex qmake)

		# Languages
		-DBUILD_PLUGIN_GLSLEDITOR=$(usex glsl)
		-DBUILD_PLUGIN_LANGUAGECLIENT=$(usex lsp)
		-DBUILD_PLUGIN_NIM=$(usex nim)
		-DBUILD_PLUGIN_PYTHON=$(usex python)

		# Platforms
		-DBUILD_PLUGIN_ANDROID=$(usex android)
		-DBUILD_PLUGIN_BAREMETAL=$(usex baremetal)
		-DBUILD_PLUGIN_BOOT2QT=$(usex boot2qt)
		-DBUILD_PLUGIN_MCUSUPPORT=$(usex mcu)
		-DBUILD_PLUGIN_QNX=$(usex qnx)
		-DBUILD_PLUGIN_REMOTELINUX=$(usex remotelinux)
		-DBUILD_PLUGIN_WEBASSEMBLY=$(usex webassembly)

		# VCS
		-DBUILD_PLUGIN_BAZAAR=$(usex bazaar)
		-DBUILD_PLUGIN_CLEARCASE=$(usex clearcase)
		-DBUILD_PLUGIN_CVS=$(usex cvs)
		-DBUILD_PLUGIN_GIT=$(usex git)
		-DBUILD_PLUGIN_GITLAB=$(usex git)
		-DBUILD_PLUGIN_MERCURIAL=$(usex mercurial)
		-DBUILD_PLUGIN_PERFORCE=$(usex perforce)
		-DBUILD_PLUGIN_SUBVERSION=$(usex subversion)

		# Executables
		-DBUILD_EXECUTABLE_BUILDOUTPUTPARSER=$(usex qmake)
		-DBUILD_EXECUTABLE_PERFPARSER=$(usex perfprofiler)
		-DBUILD_EXECUTABLE_QML2PUPPET=$(usex qml)

		# QML stuff
		-DBUILD_PLUGIN_QMLDESIGNER=$(usex qml)
		-DBUILD_PLUGIN_QMLJSEDITOR=$(usex qml)
		-DBUILD_PLUGIN_QMLPREVIEW=$(usex qml)
		-DBUILD_PLUGIN_QMLPROJECTMANAGER=$(usex qml)
		-DBUILD_PLUGIN_STUDIOWELCOME=$(usex qml)

		# Don't spam "created by a different GCC executable [-Winvalid-pch]"
		-DBUILD_WITH_PCH=NO
		# An entire mode devoted to a giant "Hello World!" button that does nothing.
		-DBUILD_PLUGIN_HELLOWORLD=NO
		# Not usable in linux environment
		-DBUILD_PLUGIN_IOS=NO
		# Use portage to update
		-DBUILD_PLUGIN_UPDATEINFO=NO

		# QT Design Studio related. Not sure how neccessary these are but they
		# should be left default-disabled for now
		#
		# -DWITH_QMLDOM=YES
		# -DUSE_PROJECTSTORAGE=YES
	)

	# Clang stuff
	if use clang; then
		mycmakeargs+=(
			-DBUILD_PLUGIN_CLANGCODEMODEL=YES
			-DBUILD_PLUGIN_CLANGFORMAT=YES
			-DBUILD_PLUGIN_CLANGTOOLS=YES
			-DCLANGTOOLING_LINK_CLANG_DYLIB=YES
			-DClang_DIR="${CLANG_PREFIX}/$(get_libdir)/cmake/clang"
			-DLLVM_DIR="${CLANG_PREFIX}/$(get_libdir)/cmake/llvm"
		)
	fi
	if use help; then
		mycmakeargs+=(
			-DBUILD_HELPVIEWERBACKEND_QTWEBENGINE=$(usex webengine)
			-DBUILD_LIBRARY_QLITEHTML=$(usex webengine NO YES)
			-DHELPVIEWER_DEFAULT_BACKEND=$(usex webengine qtwebengine litehtml)
		)
		if ! use webengine; then
			mycmakeargs+=(
				-DEXTERNAL_GUMBO=YES
				-DEXTERNAL_XXD=NO
				-DLITEHTML_UTF8=YES
			)
		fi
	fi
	if use test; then
		mycmakeargs+=(
			# Don't test pretty printing in gdb/lldb. Tests like
			# tst_debugger_dumpers fail and it's "not officially supported"
			# See share/qtcreator/debugger/README.txt
			-DWITH_DEBUGGER_DUMPERS=NO

			# Disable broken tests
			-DBUILD_TEST_TST_PERFDATA=NO
			-DBUILD_TEST_TST_QML_CHECK=NO
			-DBUILD_TEST_TST_QML_DEPENDENCIES=NO
			-DBUILD_TEST_TST_QML_TESTCORE=NO
			-DBUILD_TEST_TST_TRACING_TIMELINERENDERER=NO
		)
	fi
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	if use doc; then
		cmake_src_install doc/{qch,html}_docs
		dodoc "${BUILD_DIR}"/share/doc/${PF}/qtcreator{,-dev}.qch
		docompress -x /usr/share/doc/${PF}/qtcreator{,-dev}.qch
		docinto html
		dodoc -r "${BUILD_DIR}"/doc/html/.
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header \
		"Some enabled plugins require optional dependencies for functionality:"
	use android && optfeature "android device support" \
		dev-util/android-sdk-update-manager
	if use autotest; then
		optfeature "catch testing framework support" dev-cpp/catch
		optfeature "gtest testing framework support" dev-cpp/gtest
		optfeature "boost testing framework support" dev-libs/boost
		optfeature "qt testing framework support" dev-qt/qttest
	fi
	if use beautifier; then
		optfeature "astyle auto-formatting support" dev-util/astyle
		optfeature "uncrustify auto-formatting support" dev-util/uncrustify
	fi
	use clang && optfeature "clazy QT static code analysis" dev-util/clazy
	use conan && optfeature "conan package manager integration" dev-util/conan
	use cvs && optfeature "cvs vcs integration" dev-vcs/cvs
	use docker && optfeature "using a docker image as a device" \
		app-containers/docker
	use git && optfeature "git vcs integration" dev-vcs/git
	use mercurial && optfeature "mercurial vcs integration" dev-vcs/mercurial
	use meson && optfeature "meson buildsystem support" dev-util/meson
	use nim && optfeature "nim language support" dev-lang/nim
	use qbs && optfeature "QBS buildsystem support" dev-util/qbs
	use silversearcher && optfeature "code searching with silversearcher" \
		sys-apps/the_silver_searcher
	use subversion && optfeature "subversion vcs integration" dev-vcs/subversion
	use valgrind && optfeature "valgrind code analysis" dev-util/valgrind
}
