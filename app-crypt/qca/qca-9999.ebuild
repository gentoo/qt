# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
IUSE="botan debug doc examples gcrypt gpg logger nss openssl pkcs11 +qt4 qt5 sasl softstore test"

RDEPEND="
	botan? ( dev-libs/botan )
	sasl? ( dev-libs/cyrus-sasl )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	openssl? ( dev-libs/openssl:0 )
	pkcs11? (
		dev-libs/openssl:0
		>=dev-libs/pkcs11-helper-1.02
	)
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
	!<app-crypt/qca-1.0-r3:0"

REQUIRED_USE="^^ ( qt4 qt5 )"

DOCS=( README TODO )

with_plugin_use() {
	[[ -z $1 ]] && die "with_plugin_use <USE flag> [<flag name>]"
	echo "-DWITH_${2:-$1}_PLUGIN=$(use $1 && echo yes || echo no)"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 QT4_BUILD)
		$(cmake-utils_use test BUILD_TESTS)
		$(with_plugin_use botan)
		$(with_plugin_use sasl cyrus-sasl)
		$(with_plugin_use gcrypt)
		$(with_plugin_use gpg gnupg)
		$(with_plugin_use logger)
		$(with_plugin_use nss)
		$(with_plugin_use openssl ossl)
		$(with_plugin_use pkcs11)
		$(with_plugin_use softstore)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		pushd "${BUILD_DIR}"
		doxygen Doxyfile
		dohtml apidocs/html/*
		popd
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples
	fi
}
