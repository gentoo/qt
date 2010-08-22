# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools multilib eutils flag-o-matic subversion

DESCRIPTION="Collection of simple PIN or passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="http://www.gnupg.org/aegypten/"
ESVN_REPO_URI="svn://cvs.gnupg.org/pinentry/trunk"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="caps gtk ncurses qt4 static"

DEPEND="
	caps? ( sys-libs/libcap )
	static? ( sys-libs/ncurses )
	!static? (
		gtk? ( x11-libs/gtk+:2 )
		!gtk? (
			!qt4? ( sys-libs/ncurses )
		)
		ncurses? ( sys-libs/ncurses )
		qt4? ( x11-libs/qt-gui:4 )
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use static; then
		append-ldflags -static
		if use gtk || use qt4; then
			ewarn
			ewarn "The static USE flag is only supported with the ncurses USE flags, disabling the gtk and qt4 USE flags."
			ewarn
		fi
	fi
}

src_prepare() {
	eautoreconf
	elibtoolize
}

src_configure() {
	local myconf=""

	if use gtk || use ncurses || use qt4; then
		myconf="--enable-pinentry-curses --enable-fallback-curses"
	elif use static; then
		myconf="--enable-pinentry-curses --enable-fallback-curses --disable-pinentry-gtk2 --disable-pinentry-qt --disable-pinentry-qt4"
	fi

	econf \
		--disable-dependency-tracking \
		--enable-maintainer-mode \
		--disable-pinentry-gtk \
		$(use_enable gtk pinentry-gtk2) \
		$(use_enable qt4 pinentry-qt4) \
		$(use_enable ncurses pinentry-curses) \
		$(use_enable ncurses fallback-curses) \
		$(use_with caps libcap) \
		${myconf}
}

src_compile() {
	# Generated meta-object files manually
	if use qt4; then
		moc qt4/pinentrydialog.h -o qt4/pinentrydialog.moc && \
		moc qt4/qsecurelineedit.h -o qt4/qsecurelineedit.moc \
		|| die "failed to regenerate .moc files"
	fi

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die "dodoc failed"
}

pkg_postinst() {
	elog "We no longer install pinentry-curses and pinentry-qt SUID root by default."
	elog "Linux kernels >=2.6.9 support memory locking for unprivileged processes."
	elog "The soft resource limit for memory locking specifies the limit an"
	elog "unprivileged process may lock into memory. You can also use POSIX"
	elog "capabilities to allow pinentry to lock memory. To do so activate the caps"
	elog "USE flag and add the CAP_IPC_LOCK capability to the permitted set of"
	elog "your users."
}
