# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one"
HOMEPAGE="https://bun.sh/"
SRC_URI="https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-x64.zip -> ${P}.zip"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 ISC LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

scr_install() {
    dobin bun
}
