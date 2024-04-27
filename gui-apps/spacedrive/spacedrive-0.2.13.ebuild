# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Copyright 2019 Rabenda

EAPI=8

inherit xdg desktop unpacker

DESCRIPTION="One Explorer. All Your Files."
HOMEPAGE="https://www.spacedrive.com"
SRC_URI="
https://github.com/spacedriveapp/spacedrive/releases/download/${PV}/Spacedrive-linux-x86_64.deb
"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip mirror"

QA_PREBUILD="*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
    cp -R "${S}"/* "${D}" || die "Installing binary files failed"
    mv "${D}/usr/share/doc/spacedrive" "${D}/usr/share/doc/${PF}" || die
}
