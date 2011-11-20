EAPI="4"

inherit qt4-edge git-2

EGIT_REPO_URI="git://github.com/ariya/screenie.git"

DESCRIPTION="A small QT-based tool to allow you to compose fancy and stylish screenshots"
HOMEPAGE="http://code.google.com/p/screenie"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_install() {
	# install screenie binary
	dobin "${S}"/${MY_PN}
	doicon "${S}"/resources/${MY_PN}.png
	domenu "${S}"/${MY_PN}.desktop
}
