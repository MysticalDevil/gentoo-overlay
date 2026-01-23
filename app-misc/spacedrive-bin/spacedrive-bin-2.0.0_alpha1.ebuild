EAPI=8

inherit xdg

DESCRIPTION="Spacedrive v2 desktop app (binary release from GitHub)"
HOMEPAGE="https://github.com/spacedriveapp/spacedrive"

# Gentoo PV: 2.0.0_alpha1
# Upstream tag: v2.0.0-alpha.1
MY_TAG="v${PV/_alpha/-alpha.}"

SRC_URI="
	https://github.com/spacedriveapp/spacedrive/releases/download/${MY_TAG}/Spacedrive-linux-x86_64.deb
		-> ${P}-linux-x86_64.deb
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

QA_PREBUILT="*"

BDEPEND="
	sys-devel/binutils
	app-arch/tar
	app-arch/xz-utils
	app-arch/zstd
	app-arch/gzip
	app-arch/bzip2
	sys-apps/file
"

RDEPEND="
  media-libs/libheif
	net-libs/webkit-gtk:4.1
	dev-libs/libayatana-appindicator
"

S="${WORKDIR}/image"

src_unpack() {
	default

	mkdir -p "${WORKDIR}/deb" "${S}" || die
	cd "${WORKDIR}/deb" || die

	ar x "${DISTDIR}/${A}" || die "ar extract failed"

	local data_tar=""
	for f in data.tar.*; do
		data_tar="${f}"
		break
	done
	[[ -n "${data_tar}" ]] || die "data.tar.* not found in deb"

	case "${data_tar}" in
		*.zst)
			unzstd -c "${data_tar}" | tar -x -C "${S}" -f - || die "extract data.tar.zst failed"
			;;
		*.xz)
			unxz -c "${data_tar}" | tar -x -C "${S}" -f - || die "extract data.tar.xz failed"
			;;
		*.gz)
			gzip -dc "${data_tar}" | tar -x -C "${S}" -f - || die "extract data.tar.gz failed"
			;;
		*.bz2)
			bzip2 -dc "${data_tar}" | tar -x -C "${S}" -f - || die "extract data.tar.bz2 failed"
			;;
		*)
			# 兜底，tar 自己尝试识别
			tar -xaf "${data_tar}" -C "${S}" || die "extract ${data_tar} failed"
			;;
	esac
}

src_compile() {
	:
}

src_install() {
	if [[ -d "${S}/usr" ]]; then
		cp -a "${S}/usr" "${ED}/" || die
	fi

	if [[ -d "${S}/opt" ]]; then
		cp -a "${S}/opt" "${ED}/" || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Upstream tag used: ${MY_TAG}"
	elog "If the release asset filename changes, update SRC_URI accordingly."
}

pkg_postrm() {
	xdg_pkg_postrm
}

