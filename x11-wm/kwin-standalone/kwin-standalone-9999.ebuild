# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils git-2

DESCRIPTION="KWin version that only depends on kdelibs"
HOMEPAGE="https://groups.google.com/group/razor-qt/msg/b1d21a0cb8b665a2"
SRC_URI=""
EGIT_REPO_URI="git://anongit.kde.org/clones/kde-workspace/graesslin/kde-workspace.git"
EGIT_BRANCH="kwin/standalone"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gles opengl"
REQUIRED_USE="!opengl? ( gles ) !gles? ( opengl )"

DEPEND="kde-base/kdelibs:4
	!kde-base/kwin"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/kwin"

src_prepare() {
	sed -i -e "s:set(KWIN_NAME \"kwin\"):set(KWIN_NAME \"${PN}\"):" \
		"${CMAKE_USE_DIR}/CMakeLists.txt" || die
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with gles OpenGLES)
		$(cmake-utils_use gles KWIN_BUILD_WITH_OPENGLES)
		$(cmake-utils_use_with opengl OpenGL)
		-DWITH_X11_Xcomposite=ON
		-DKWIN_BUILD_OXYGEN=OFF
		-DKWIN_BUILD_KCMS=OFF
		-DKWIN_BUILD_KAPPMENU=OFF
		-DKWIN_BUILD_ACTIVITIES=OFF
	)

	cmake-utils_src_configure
}
