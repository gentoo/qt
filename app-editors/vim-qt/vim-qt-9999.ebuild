# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs flag-o-matic git-2

DESCRIPTION="Qt GUI version of the Vim text editor"
HOMEPAGE="https://bitbucket.org/equalsraf/vim-qt/wii/Home"
EGIT_REPO_URI="https://bitbucket.org/equalsraf/${PN}.git
	git://github.com/equalsraf/${PN}.git
	git://gitorious.org/${PN}/${PN}.git"

LICENSE="vim"
SLOT="0"
KEYWORDS=""
IUSE="acl cscope debug gpm nls perl python ruby"

RDEPEND="
	app-admin/eselect-vi
	>=app-editors/vim-core-7.3.487
	sys-libs/ncurses
	>=x11-libs/qt-core-4.7.0:4
	>=x11-libs/qt-gui-4.7.0:4
	acl? ( kernel_linux? ( sys-apps/acl ) )
	cscope? ( dev-util/cscope )
	gpm? ( sys-libs/gpm )
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby:1.8 )"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

src_configure() {
	use debug && append-flags "-DDEBUG"

	local myconf="--with-features=huge --enable-multibyte"
	myconf+=" $(use_enable acl)"
	myconf+=" $(use_enable gpm)"
	myconf+=" $(use_enable nls)"
	myconf+=" $(use_enable perl perlinterp)"
	myconf+=" $(use_enable python pythoninterp)"
	myconf+=" $(use_enable ruby rubyinterp)"
	myconf+=" --enable-gui=qt --with-vim-name=qvim --with-x"

	if ! use cscope ; then
		sed -i -e '/# define FEAT_CSCOPE/d' src/feature.h || \
			die "couldn't disable cscope"
	fi
	econf ${myconf}
}

src_install() {
	dobin src/qvim
	doicon -s 64 src/qt/icons/vim-qt.png
	make_desktop_entry qvim Vim-qt vim-qt "Qt;TextEditor;Development;"
}
