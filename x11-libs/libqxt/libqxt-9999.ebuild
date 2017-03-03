# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils git-r3

DESCRIPTION="Extension library providing cross-platform utility classes for the Qt toolkit"
HOMEPAGE="https://bitbucket.org/libqxt/libqxt/wiki/Home"
EGIT_REPO_URI="https://bitbucket.org/${PN}/${PN}.git"

LICENSE="|| ( CPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS=""
IUSE="berkdb debug doc sql web xscreensaver zeroconf"

COMMON_DEPEND="
	dev-qt/designer:4
	dev-qt/qtcore:4[ssl]
	dev-qt/qtgui:4
	x11-libs/libXrandr
	berkdb? ( >=sys-libs/db-4.6:= )
	sql? ( dev-qt/qtsql:4 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${COMMON_DEPEND}
	doc? ( dev-qt/qthelp:4 )
"
RDEPEND="${COMMON_DEPEND}
	xscreensaver? ( x11-libs/libXScrnSaver )
"

DOCS=( AUTHORS CHANGES README )
PATCHES=(
	"${FILESDIR}/${PN}-use-system-qdoc3.patch"
)

src_prepare() {
	default

	# remove insecure runpath
	sed -i -e '/^QMAKE_RPATHDIR /d' src/qxtlibs.pri || die
}

src_configure() {
	# custom configure script
	local myconf=(
		./configure -verbose
		-prefix "${EPREFIX}/usr"
		-libdir "${EPREFIX}/usr/$(get_libdir)"
		-docdir "${EPREFIX}/usr/share/doc/${PF}"
		-qmake-bin "$(qt4_get_bindir)/qmake"
		$(use debug && echo -debug || echo -release)
		$(use berkdb || echo -no-db -nomake berkeley)
		$(use doc || echo -nomake docs)
		$(use sql || echo -nomake sql)
		$(use web || echo -nomake web)
		$(use zeroconf || echo -no-zeroconf -nomake zeroconf)
	)
	echo "${myconf[@]}"
	"${myconf[@]}" || die "./configure failed"

	eqmake4 -recursive
}

src_compile() {
	default

	use doc && emake docs
}

pkg_postinst() {
	if use doc; then
		einfo
		einfo "In case you want to browse ${PN} documentation using"
		einfo "Qt Assistant, perform the following steps:"
		einfo "  1. Open the Assistant"
		einfo "  2. Edit -> Preferences -> Documentation -> Add"
		einfo "  3. Add this path: ${EPREFIX}/usr/share/doc/${PF}/qxt.qch"
		einfo
	fi
}
