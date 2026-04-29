# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

MY_PV="0.2026.04.27.15.32.stable.02"
MY_DIR="v0.2026.04.27.15.32.stable_02"
MY_DEB="warp-terminal_${MY_PV}_amd64.deb"

DESCRIPTION="Warp, the Rust-based terminal for developers and teams"
HOMEPAGE="https://www.warp.dev/"
SRC_URI="https://releases.warp.dev/stable/${MY_DIR}/${MY_DEB} -> ${P}.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

BDEPEND="
	app-arch/xz-utils
"
RDEPEND="
	app-arch/xz-utils
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libglvnd
	media-libs/mesa
	virtual/zlib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/libxkbcommon
"

QA_PRESTRIPPED="opt/warpdotdev/warp-terminal/warp"

src_install() {
	cp -a opt "${ED}/" || die
	cp -a usr "${ED}/" || die

	sed -i 's/^Icon=dev\.warp\.Warp$/Icon=warp/' \
		"${ED}/usr/share/applications/dev.warp.Warp.desktop" || die

	local icon
	for icon in "${ED}"/usr/share/icons/hicolor/*/apps/dev.warp.Warp.png; do
		cp "${icon}" "${icon%/*}/warp.png" || die
	done

	dosym ../icons/hicolor/256x256/apps/warp.png /usr/share/pixmaps/warp.png
	dosym ../../opt/warpdotdev/warp-terminal/warp /usr/bin/warp-terminal
}
