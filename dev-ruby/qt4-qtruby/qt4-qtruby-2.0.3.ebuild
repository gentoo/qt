# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit cmake-utils

DESCRIPTION="Ruby bindings for Qt4"
HOMEPAGE="http://rubyforge.org/projects/korundum"
SRC_URI="http://rubyforge.org/frs/download.php/53816/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="assistant phonon qt3support qtscript qscintilla qttest qwt webkit xmlpatterns"

RDEPEND=">=virtual/ruby-1.8
	x11-libs/qt-gui[dbus]
	x11-libs/qt-opengl
	x11-libs/qt-sql
	x11-libs/qt-svg
	assistant? ( x11-libs/qt-assistant )
	phonon? ( x11-libs/qt-phonon )
	qt3support? ( x11-libs/qt-qt3support )
	qtscript? ( x11-libs/qt-script )
	qttest? ( x11-libs/qt-test )
	webkit? ( x11-libs/qt-webkit )
	xmlpatterns? ( x11-libs/qt-xmlpatterns )
	qscintilla? ( =x11-libs/qscintilla-2* )
	qwt? ( x11-libs/qwt:5 )"
DEPEND="${RDEPEND}"

# Dev notes:
# Check the CMakeLists for optional components and automagic dependencies!
# I'm not sure if the QT_USE_* options below actually work...
# Also, make sure we are multilib compatible.
# USE=qwt fails... but it's optional now.
# This currently also installs Qt.rb and Qt3.rb, but i think we only want
# Qt4.rb.

# Linking qttest.so failes with: cannot find -lsmokekde, bug 224951
PATCHES=( "${FILESDIR}/${PV}_nosmokekde.patch" )

src_configure() {
	local MY_RUBYINC=$( ruby -rrbconfig -e 'puts Config::CONFIG["rubyhdrdir"]' )
	if [[ $MY_RUBYINC = nil ]]; then
		MY_RUBYINC=$( ruby -rrbconfig -e 'puts Config::CONFIG["archdir"]' )
	fi
	local MY_LIBRUBY=$( ruby -rrbconfig -e 'puts File.join(Config::CONFIG["libdir"], Config::CONFIG["LIBRUBY"])' )

	# point to detected include and lib locations
	# and build smokeqt but not smokekde
	mycmakeargs="${mycmakeargs}
	-DRUBY_INCLUDE_PATH=$MY_RUBYINC
	-DRUBY_LIBRARY=$MY_LIBRUBY
	-DENABLE_QTRUBY=on
	-DENABLE_SMOKE=on
	-DENABLE_SMOKEKDE=off
	-DQT_USE_QTDESIGNER=true
	$(cmake-utils_use assistant QT_USE_QTASSISTANT)
	$(cmake-utils_use assistant QT_USE_QTASSISTANTCLIENT)
	$(cmake-utils_use phonon QT_USE_PHONON)
	$(cmake-utils_use_enable phonon PHONON_RUBY)
	$(cmake-utils_use_enable phonon PHONON_SMOKE)
	$(cmake-utils_use qt3support QT_USE_QT3SUPPORT)
	$(cmake-utils_use_enable qtscript QTSCRIPT)
	$(cmake-utils_use_enable qtscript QTSCRIPT-SMOKE)
	$(cmake-utils_use_enable qttest QTTEST)
	$(cmake-utils_use_enable qttest QTTEST-SMOKE)
	$(cmake-utils_use_enable webkit QTWEBKIT_RUBY)
	$(cmake-utils_use_enable webkit QTWEBKIT_SMOKE)
	$(cmake-utils_use xmlpatterns QT_USE_QTXMLPATTERNS)
	$(cmake-utils_use_enable qscintilla QSCINTILLA_RUBY)
	$(cmake-utils_use_enable qscintilla QSCI-SMOKE)
	$(cmake-utils_use_enable qwt QWT_RUBY)
	$(cmake-utils_use_enable qwt QWT-SMOKE)
	-Wno-dev"

	cmake-utils_src_configure
}
