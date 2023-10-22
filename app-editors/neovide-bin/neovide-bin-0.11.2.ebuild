# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Neovide: No Nonsense Neovim Gui"
HOMEPAGE="https://neovide.dev"
SRC_URI="https://github.com/neovide/neovide/releases/download/${PV}/neovide-linux-x86_64.tar.gz -> ${P}.tar.gz"
RESTRICT="fetch"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

S="${WORKDIR}"

RDEPEND="
>=virtual/rust-1.53
>=app-editors/neovim-0.9
"

QA_FLAGS_IGNORED="usr/bin/neovide"
QA_TEXTRELS="usr/bin/neovide"

src_install() {
	dobin neovide
}
