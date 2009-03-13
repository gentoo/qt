# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator distutils

MY_PN="${PN/p/P}"
MY_P="${MY_PN}-$(replace_version_separator 2 '')1"

DESCRIPTION="Pythonn-based scripting tool"
HOMEPAGE="http://www.blueskyonmars.com/projects/paver/"
SRC_URI="http://pypi.python.org/packages/source/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LICENSE-PAVER.txt"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	# overriding default functions as --no_compile option is not supported
	pylibdir="$(${python} -c 'from distutils.sysconfig import get_python_lib; print get_python_lib()')"
	[ -n "${pylibdir}" ] && dodir "${pylibdir}"
	${python} setup.py install --root="${D}" "$@" || \
	die "python setup.py install failed"
	dodoc README.txt || die "dodoc failed"
}
