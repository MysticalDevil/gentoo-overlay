# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

MY_PV="${PV/_beta/-beta}"
MY_P="${PN}-${MY_PV}"
QTW_COMMIT="d86ebbc396ece6ed46b30eaa1ebead138ab7f2a4"
QTW_P="qmltermwidget-${QTW_COMMIT}"
KDSA_COMMIT="1848dd64e80e37326da4a22b2c1f45f2a1c4f231"
KDSA_P="KDSingleApplication-${KDSA_COMMIT}"

DESCRIPTION="Terminal emulator with an old school look and feel"
HOMEPAGE="https://github.com/Swordfish90/cool-retro-term/"

SRC_URI="
	https://github.com/Swordfish90/cool-retro-term/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	https://github.com/Swordfish90/qmltermwidget/archive/${QTW_COMMIT}.tar.gz -> ${QTW_P}.tar.gz
	https://github.com/KDAB/KDSingleApplication/archive/${KDSA_COMMIT}.tar.gz -> ${KDSA_P}.tar.gz
"

S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-2+ GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtshadertools:6
"

RDEPEND="${DEPEND}
	virtual/opengl"

src_prepare() {
	default

	rmdir qmltermwidget || die
	rmdir KDSingleApplication || die
	mv "${WORKDIR}/${QTW_P}" qmltermwidget || die
	mv "${WORKDIR}/${KDSA_P}" KDSingleApplication || die
}

src_configure() {
	eqmake6 PREFIX="${EPREFIX}/usr"
}

src_install() {
	# `default` attempts to install directly to /usr and parallelised
	# installation is not supported as `qmake -install` does not implicitly
	# create target directory.
	emake -j1 INSTALL_ROOT="${ED}" install
	doman "packaging/debian/cool-retro-term.1"

	insinto "/usr/share/metainfo"
	doins "packaging/appdata/cool-retro-term.appdata.xml"
}
