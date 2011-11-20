EAPI="4"

inherit qt4-edge git-2 multilib

EGIT_REPO_URI="git://github.com/ariya/screenie.git"

DESCRIPTION="A small QT-based tool to allow you to compose fancy and stylish screenshots"
HOMEPAGE="http://code.google.com/p/screenie"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_prepare () {
	qt4-edge_src_prepare
	sed -i -e "/^Exec/s:Screenie:${PN}:" -e "/^TryExec/s:Screenie:${PN}:" \
		"${S}"/src/Screenie/res/${PN}.desktop || die
}

src_install() {
	# The package uses generic library names that make cause collisions
	# in the future. They need to be moved to a subfolder
	dolib.so "${S}"/bin/release/*.so*
	newbin "${S}"/bin/release/Screenie ${PN}
	newicon "${S}"/src/Resources/img/application-icon.png ${PN}.png
	domenu "${S}"/src/Screenie/res/${PN}.desktop
}
