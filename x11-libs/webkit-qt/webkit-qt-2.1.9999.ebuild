# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_REPO_URI="git://gitorious.org/+qtwebkit-developers/webkit/qtwebkit.git"
EGIT_PROJECT="qtwebkit-${PV}"
EGIT_BRANCH="qtwebkit-2.1"

inherit git

DESCRIPTION="The Webkit module for the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="coverage debug glib introspection kde mobile static-libs"

#minimum Qt Version
QTVER="4.7.0_beta2"
DEPEND="net-libs/libsoup
	dev-libs/libxslt
	x11-libs/pango
	x11-libs/cairo
	glib? ( dev-libs/glib )
	db? ( dev-db/sqlite:3 )
	>=x11-libs/qt-core-${QTVER}[ssl]
	>=x11-libs/qt-gui-${QTVER}[dbus?]
	>=x11-libs/qt-xmlpatterns-${QTVER}
	>=x11-libs/qt-xmlpatterns-${QTVER}
	dbus? ( >=x11-libs/qt-dbus-${QTVER} )
	!kde? ( || ( >=x11-libs/qt-phonon-${QTVER}:${SLOT}[dbus=]
		media-sound/phonon ) )
	kde? ( media-sound/phonon )
	!net-misc/webkit-gtk"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${S}"
	# cant figure out which autotools functions to use
	sed -i -e "/\$srcdir\/configure/d" \
		-e "s:\$top_srcdir:"${S}":" autogen.sh
	./autogen.sh
}

src_configure() {
	myconf="
		$(use_enable debug) 
		$(use_enable svg)
		$(use_enable doc gkt-doc-html) --enable-web-sockets \
		$(use_enable coverage) $(use_enable mobile fast-mobile-scrolling) \
		$(use_enable introspection) --enable-mathml shared \
		$(use_enable static-libs static)"
	use debug && myconf="${myconf} --disable-fast-malloc"
	use doc && myconf="${myconf} --with-html-dir=/usr/share/doc/${PF}/"
	use glib && myconf"${myconf} --with-unicode-backend=glib"
	
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
