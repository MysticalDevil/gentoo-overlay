# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="JetBrains Toolbox - Manage your JetBrains tools"
HOMEPAGE="https://www.jetbrains.com/toolbox-app/"

SRC_URI="
	amd64? ( https://download.jetbrains.com/toolbox/${P}.tar.gz )
	arm64? ( https://download.jetbrains.com/toolbox/${P}-arm64.tar.gz )
"

LICENSE="JetBrains"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror strip bindist"

RDEPEND="
	sys-fs/fuse:0
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	media-libs/mesa
	media-libs/fontconfig
	x11-libs/gtk+:3
	dev-libs/nss
"
DEPEND=""
BDEPEND=""

QA_PREBUILT="opt/${P}/*"

src_unpack() {
	default

	local target_dir="${WORKDIR}/${P}"

	if [[ ! -d "${target_dir}" ]]; then
		local unpacked_dir
		unpacked_dir=$(find "${WORKDIR}" -maxdepth 1 -type d -name "jetbrains-toolbox*" | head -n 1)
		if [[ -n "${unpacked_dir}" && "${unpacked_dir}" != "${target_dir}" ]]; then
			mv "${unpacked_dir}" "${target_dir}" || die
		fi
	fi
}

src_install() {
	local install_dir="/opt/${P}"

	dodir "${install_dir}"

	# Copy everything (including dotfiles) while preserving perms/symlinks.
	cp -a "${S}"/. "${ED}${install_dir}/" || die

	# Prefer upstream bin/ layout; fallback to top-level executable if it ever changes.
	local exe="${install_dir}/bin/${PN}"
	[[ -x "${ED}${exe}" ]] || exe="${install_dir}/${PN}"
	dosym "${exe}" "/usr/bin/${PN}"

	# Do NOT install tray icon as app icon.
	# Rely on the system icon theme providing "jetbrains-toolbox" (e.g. Papirus), via Icon=jetbrains-toolbox.
	make_desktop_entry "/usr/bin/${PN}" "JetBrains Toolbox" "${PN}" "Development;IDE;"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "JetBrains Toolbox has been installed to /opt/${P}"
	elog "A symlink has been created at /usr/bin/${PN}"
	elog ""
	elog "On first run, it may install a user-level copy under ~/.local/share/JetBrains/Toolbox"
	elog "and manage autostart configuration."
	elog ""
	elog "If you encounter launch issues under Hyprland (e.g. AppImage mount failures),"
	elog "make sure your user can access the FUSE device, and that sys-fs/fuse is properly loaded."
}
