# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="Demonstration module and examples for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-macos"
fi

IUSE="dbus declarative kde multimedia opengl openvg phonon webkit xmlpatterns"

DEPEND="
	~dev-qt/designer-${PV}[aqua=,debug=]
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=]
	~dev-qt/qthelp-${PV}[aqua=,debug=]
	~dev-qt/qtscript-${PV}[aqua=,debug=]
	~dev-qt/qtsql-${PV}[aqua=,debug=]
	~dev-qt/qtsvg-${PV}[aqua=,debug=]
	~dev-qt/qttest-${PV}[aqua=,debug=]
	dbus? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=] )
	declarative? ( ~dev-qt/qtdeclarative-${PV}[aqua=,debug=,webkit?] )
	multimedia? ( ~dev-qt/qtmultimedia-${PV}[aqua=,debug=] )
	opengl? ( ~dev-qt/qtopengl-${PV}[aqua=,debug=] )
	openvg? ( ~dev-qt/qtopenvg-${PV}[aqua=,debug=] )
	phonon? (
		kde? ( media-libs/phonon[aqua=] )
		!kde? ( || ( ~dev-qt/qtphonon-${PV}[aqua=,debug=] media-libs/phonon[aqua=] ) )
	)
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=] )
	xmlpatterns? ( ~dev-qt/qtxmlpatterns-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.6-plugandpaint.patch"
)

QT4_TARGET_DIRECTORIES="
	demos
	examples"

QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	doc/src/images
	include
	src
	tools"

src_prepare() {
	qt4-build-multilib_src_prepare

	# Array mapping USE flags to subdirs
	local flags_subdirs_map=(
		'dbus'
		'declarative:declarative'
		'multimedia:spectrum'
		'opengl:boxes|glhypnotizer'
		'openvg'
		'phonon:mediaplayer'
		'webkit:browser'
		'xmlpatterns'
	)

	# Disable unwanted examples/demos
	for flag in "${flags_subdirs_map[@]}"; do
		if ! use ${flag%:*}; then
			einfo "Disabling ${flag%:*} examples"
			sed -i -e "/SUBDIRS += ${flag%:*}/d" \
				examples/examples.pro || die

			if [[ ${flag} == *:* ]]; then
				einfo "Disabling ${flag%:*} demos"
				sed -i -re "/SUBDIRS \+= demos_(${flag#*:})/d" \
					demos/demos.pro || die
			fi
		fi
	done

	# Remove bogus dependency on qt3support (bug 510042)
	sed -i -e 's/contains(QT_CONFIG, qt3support)://' \
		examples/graphicsview/graphicsview.pro || die
}

src_configure() {
	myconf+="
		$(qt_use dbus)
		$(qt_use declarative)
		$(qt_use multimedia) -no-audio-backend
		$(qt_use opengl)
		$(qt_use openvg)
		$(qt_use phonon) -no-phonon-backend
		$(qt_use webkit)
		$(qt_use xmlpatterns)"

	qt4-build-multilib_src_configure
}

src_install() {
	insinto "${QT4_DOCDIR#${EPREFIX}}"/src
	doins -r doc/src/images

	qt4-build-multilib_src_install
}
