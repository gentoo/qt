# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libfm/libfm-9999.ebuild,v 1.39 2014/03/06 20:34:11 hwoarang Exp $

EAPI=5

EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}"

inherit autotools git-r3 fdo-mime vala eutils

DESCRIPTION="A library for file management"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+automount debug doc examples gtk udisks vala"
REQUIRED_USE="udisks? ( automount )"

KEYWORDS=""
COMMON_DEPEND="!lxde-base/lxshortcut
	>=dev-libs/glib-2.18:2
	>=lxde-base/menu-cache-0.3.2:=
	media-libs/libexif
	gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
	automount? (
		udisks? ( || (
			gnome-base/gvfs[udev,udisks]
			gnome-base/gvfs[udev,gdu]
		) )
		!udisks? ( gnome-base/gvfs[udev] )
	)"
DEPEND="${COMMON_DEPEND}
	vala? ( $(vala_depend) )
	doc? (
		dev-util/gtk-doc
	)
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS TODO )

src_prepare() {
	if ! use doc; then
		sed -ie '/^SUBDIR.*=/s#docs##' "${S}"/Makefile.am || die "sed failed"
		sed -ie '/^[[:space:]]*docs/d' configure.ac || die "sed failed"
	else
		gtkdocize --copy || die
	fi
	sed -i -e "s:-O0::" -e "/-DG_ENABLE_DEBUG/s: -g::" \
		configure.ac || die "sed failed"

	intltoolize --force --copy --automake || die
	#disable unused translations. Bug #356029
	for trans in app-chooser ask-rename exec-file file-prop preferred-apps \
		progress;do
		echo "data/ui/"${trans}.ui >> po/POTFILES.in
	done
	#Remove -Werror for automake-1.12. Bug #421101
	sed -i "s:-Werror::" configure.ac || die

	eautoreconf
	rm -r autom4te.cache || die
	use vala && export VALAC="$(type -p valac-$(vala_best_api_version))"
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable examples demo) \
		$(use_enable debug) \
		$(use_enable udisks) \
		$(use_enable vala actions) \
		$(use_enable doc gtk-doc) \
		$(use_with gtk )
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html"
}

src_install() {
	default
	prune_libtool_files
	# Remove broken symlink #439570
	# Sometimes a directory is created instead of a symlink. No idea why...
	# It is wrong anyway. We expect a libfm-1.0 directory and then a libfm
	# symlink to it.
	if [[ -h ${ED}/usr/include/${PN} || -d ${ED}/usr/include/${PN} ]]; then
		rm -r "${ED}"/usr/include/${PN}
	fi
}

pkg_preinst() {
	# Resolve the symlink mess. Bug #439570
	rm -rf "${EROOT}"/usr/include/${PN}
	if [[ -d "${ED}"/usr/include/${PN}-1.0 ]]; then
		cd "${ED}"/usr/include
		ln -s --force ${PN}-1.0 ${PN}
	fi
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
