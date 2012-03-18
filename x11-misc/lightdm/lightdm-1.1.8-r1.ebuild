# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lightdm/lightdm-1.1.8.ebuild,v 1.1 2012/03/16 22:29:52 hwoarang Exp $

EAPI=4
inherit autotools eutils pam

DESCRIPTION="A lightweight display manager"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/LightDM"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz
	mirror://gentoo/introspection-20110205.m4.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk +introspection qt4"

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2
	sys-apps/accountsservice
	virtual/pam
	x11-libs/libxklavier
	x11-libs/libX11
	introspection? ( dev-libs/gobject-introspection )
	qt4? ( x11-libs/qt-core:4
		x11-libs/qt-dbus:4
		x11-libs/qt-gui:4 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	gnome-base/gnome-common
	sys-devel/gettext"
PDEPEND="gtk? ( x11-misc/lightdm-gtk-greeter )"

DOCS=( NEWS )

src_prepare() {
	sed -i -e "/minimum-uid/s:500:1000:" data/users.conf || die
	sed -i -e "s:gtk+-3.0:gtk+-2.0:" configure.ac || die
	epatch "${FILESDIR}"/session-wrapper-${PN}.patch
	if has_version dev-libs/gobject-introspection; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi
}

src_configure() {
	# Set default values if global vars unset
	local _greeter _session _user
	_greeter=${LIGHTDM_GREETER:=lightdm-gtk-greeter}
	_session=${LIGHTDM_SESSION:=gnome}
	_user=${LIGHTDM_USER:=root}
	# Let user know how lightdm is configured
	einfo "Gentoo configuration"
	einfo "Default greeter: ${_greeter}"
	einfo "Default session: ${_session}"
	einfo "Greeter user: ${_user}"

	# do the actual configuration
	econf --localstatedir=/var \
		--disable-static \
		--disable-tests \
		$(use_enable introspection) \
		$(use_enable qt4 liblightdm-qt) \
		--with-user-session=${_session} \
		--with-greeter-session=${_greeter} \
		--with-greeter-user=${_user} \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default

	# Install missing files
	insinto /etc/${PN}/
	doins "${S}"/data/{${PN},users,keys}.conf
	doins "${FILESDIR}"/Xsession
	fperms +x /etc/${PN}/Xsession
	# remove .la files
	find "${ED}" -name "*.la" -exec rm -rf {} +
	rm -Rf "${ED}"/etc/init || die

	dopamd "${FILESDIR}"/${PN}
	dopamd "${FILESDIR}"/${PN}-autologin
}

pkg_postinst() {
	elog
	elog "You will need to install a greeter as actual GUI for LightDM."
	elog "Currently available greeters include:"
	elog "    x11-misc/lightdm-gtk-greeter"
	elog "    x11-wm/razorqt with USE=lightdm"
	elog
	elog "Even though the default /etc/${PN}/${PN}.conf will work for"
	elog "most users, make sure you configure it to suit your needs"
	elog "before using ${PN} for the first time."
	elog "You can test the configuration file using the following"
	elog "command: ${PN} --test-mode -c /etc/${PN}/${PN}.conf. This"
	elog "requires xorg-server to be built with the 'kdrive' useflag."
	elog
	elog "You can also set your own default values for LIGHTDM_GREETER,"
	elog "LIGHTDM_SESSION, LIGHTDM_USER in /etc/make.conf"
	elog
}
