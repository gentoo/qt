# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

EGIT_REPO_URI="git://gitorious.org/qt-labs/messagingframework.git
		https://git.gitorious.org/qt-labs/messagingframework.git"

inherit qt4-r2 git-2

DESCRIPTION="The Qt Messaging Framework"
HOMEPAGE="http://qt.gitorious.org/qt-labs/messagingframework"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc examples test"

RDEPEND=">=x11-libs/qt-core-4.6.0
	>=x11-libs/qt-gui-4.6.0
	>=x11-libs/qt-sql-4.6.0
	examples? ( >=x11-libs/qt-webkit-4.6.0 )"
DEPEND="${RDEPEND}
	test? ( >=x11-libs/qt-test-4.6.0 )"

DOCS="CHANGES"
PATCHES=(
	# http://bugreports.qt.nokia.com/browse/QTMOBILITY-374
	"${FILESDIR}/${PN}-use-standard-install-paths.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	sed -i	-e '/benchmarks/d' \
		-e '/tests/d' \
		messagingframework.pro

	if ! use examples; then
		sed -i -e '/examples/d' messagingframework.pro
	fi

	sed -i -e 's:QTEST_MAIN:QTEST_APPLESS_MAIN:' tests/tst_*/*.cpp
}

src_test() {
	echo ">>> Test phase [QTest]: ${CATEGORY}/${PF}"

	cd "${S}"/tests

	einfo "Building tests"
	eqmake4 && emake

	einfo "Running tests"
	export QMF_DATA="${T}"
	local fail=false test=
	for test in locks longstream longstring qlogsystem \
			qmailaddress qmailcodec qmaillog qmailmessage \
			qmailmessagebody qmailmessageheader qmailmessagepart \
			qmailnamespace qprivateimplementation; do
		if ! ./tst_${test}/build/tst_${test}; then
			eerror "!!! ${test} test failed !!!"
			fail=true
		fi
		echo
	done
	${fail} && die "some tests have failed"
}

src_install() {
	qt4-r2_src_install

	if use doc; then
		emake docs || die "failed to generate documentation"

		dohtml -r doc/html/*
		insinto /usr/share/doc/${PF}
		doins doc/html/qmf.qch
	fi
}
