# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="localstorage"

# TODO: easingcurveeditor|qmlscene? ( qt-widgets )
# TODO: xml? ( qt-xmlpatterns )

DEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	~dev-qt/qtgui-${PV}[debug=,opengl]
	~dev-qt/qtjsbackend-${PV}[debug=]
	~dev-qt/qtnetwork-${PV}[debug=]
	~dev-qt/qttest-${PV}[debug=]
	~dev-qt/qtwidgets-${PV}[debug=]
	localstorage? ( ~dev-qt/qtsql-${PV}[debug=] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt5-build_src_prepare

	use localstorage || sed -i -e '/localstorage/d' \
		src/imports/imports.pro || die
}
