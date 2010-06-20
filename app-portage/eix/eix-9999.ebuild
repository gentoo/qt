# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eix/eix-0.15.6.ebuild,v 1.2 2010/03/28 14:12:52 darkside Exp $

EAPI="2"
ESVN_REPO_URI="https://svn.gentooexperimental.org/eix/trunk"
ESVN_BOOTSTRAP="./autogen.sh"

inherit multilib subversion

DESCRIPTION="Search and query ebuilds, portage incl. local settings, ext.
overlays, version changes, and more"
HOMEPAGE="http://eix.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc sqlite"

RDEPEND="sqlite? ( dev-db/sqlite:3 )
	app-arch/bzip2
	|| (
		app-arch/lzma-utils
		app-arch/xz-utils
	)
	dev-vcs/cvs"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )"

src_configure() {
	econf --with-bzip2 $(use_with sqlite) $(use_with doc rst) \
		--with-ebuild-sh-default="/usr/$(get_libdir)/portage/bin/ebuild.sh" \
		--with-portage-rootpath="${ROOTPATH}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog doc/format.txt
	use doc && dodoc doc/format.html
}

pkg_postinst() {
	ewarn
	ewarn "Security Warning:"
	ewarn
	ewarn "Since >=eix-0.12.0, eix uses by default OVERLAY_CACHE_METHOD=\"parse|ebuild*\""
	ewarn "This is rather reliable, but ebuilds may be executed by user \"portage\". Set"
	ewarn "OVERLAY_CACHE_METHOD=parse in /etc/eixrc if you do not trust the ebuilds."
	if test -d /var/log && ! test -x /var/log || test -e /var/log/eix-sync.log
	then
		einfo
		einfo "eix-sync no longer supports redirection to /var/log/eix-sync.log"
		einfo "You can remove that file."
	fi
}
