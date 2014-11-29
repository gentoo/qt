# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils multilib multibuild git-r3

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""

IUSE="botan debug doc examples gcrypt gpg logger nss openssl pkcs11 +qt4 qt5 sasl softstore test"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	!app-crypt/qca-cyrus-sasl
	!app-crypt/qca-gnupg
	!app-crypt/qca-logger
	!app-crypt/qca-ossl
	!app-crypt/qca-pkcs11
	botan? ( dev-libs/botan )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	openssl? ( dev-libs/openssl:0 )
	pkcs11? (
		dev-libs/openssl:0
		dev-libs/pkcs11-helper
	)
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

DOCS=( README TODO )

qca_plugin_use() {
	echo "-DWITH_${2:-$1}_PLUGIN=$(use $1 && echo yes || echo no)"
}

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	if use qt4; then
		MULTIBUILD_VARIANTS+=( qt4 )
	fi
	if use qt5; then
		MULTIBUILD_VARIANTS+=( qt5 )
	fi
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/$(usex qt4 qt4 qt5)/plugins"
			-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}/usr/$(usex qt4 share $(get_libdir))/$(usex qt4 qt4 qt5)/mkspecs/features"
			$(qca_plugin_use botan)
			$(qca_plugin_use gcrypt)
			$(qca_plugin_use gpg gnupg)
			$(qca_plugin_use logger)
			$(qca_plugin_use nss)
			$(qca_plugin_use openssl ossl)
			$(qca_plugin_use pkcs11)
			$(qca_plugin_use sasl cyrus-sasl)
			$(qca_plugin_use softstore)
			$(cmake-utils_use_build test TESTS)
		)

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=( -DQT4_BUILD=true )
		fi

		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=( -DQCA_SUFFIX=QT5 )
		fi

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile

	if use doc; then
		pushd "${BUILD_DIR}" > /dev/null
		doxygen . || die
		popd > /dev/null
	fi
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install

	if use doc; then
		pushd "${BUILD_DIR}" > /dev/null
		dodoc -r html
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}"/examples
	fi
}
