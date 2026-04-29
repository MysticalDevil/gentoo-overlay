# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

MY_COMMIT="2d3fb3a2a7a23995791f2f7b621e933cf300ec7d"

inherit distutils-r1

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="
	https://github.com/tree-sitter/py-tree-sitter/
	https://pypi.org/project/tree-sitter/
"
SRC_URI="
	https://github.com/tree-sitter/py-tree-sitter/archive/${MY_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/py-tree-sitter-${MY_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="=dev-libs/tree-sitter-0.26*:="
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' 3.12 3.13)
"
BDEPEND="
	test? (
		>=dev-libs/tree-sitter-html-0.23.2[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-javascript-0.25.0[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-json-0.24.8[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-python-0.25.0[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-rust-0.24.0[python,${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/tree-sitter-0.22.2-unbundle.patch
)

src_unpack() {
	default
	rmdir "${S}/tree_sitter/core" || die
}

src_test() {
	rm -r tree_sitter || die
	distutils-r1_src_test
}
