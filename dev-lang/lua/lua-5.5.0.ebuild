# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="https://www.lua.org/"
SRC_URI="https://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.5"
KEYWORDS="~amd64 ~arm64"
IUSE="+deprecated readline"

DEPEND="
	>=app-eselect/eselect-lua-3
	readline? ( sys-libs/readline:= )
	!dev-lang/lua:0"
RDEPEND="${DEPEND}"

LUA_HEADERS=(
	lauxlib.h
	lua.h
	lua.hpp
	luaconf.h
	lualib.h
)

LUA_LIB_OBJECTS=(
	lapi.o
	lcode.o
	lctype.o
	ldebug.o
	ldo.o
	ldump.o
	lfunc.o
	lgc.o
	llex.o
	lmem.o
	lobject.o
	lopcodes.o
	lparser.o
	lstate.o
	lstring.o
	ltable.o
	ltm.o
	lundump.o
	lvm.o
	lzio.o
	lauxlib.o
	lbaselib.o
	lcorolib.o
	ldblib.o
	liolib.o
	lmathlib.o
	loadlib.o
	loslib.o
	lstrlib.o
	ltablib.o
	lutf8lib.o
	linit.o
)

src_prepare() {
	default

	sed -i 's|#define LUA_ROOT[[:space:]]*"/usr/local/"|#define LUA_ROOT "/usr/"|' \
		src/luaconf.h || die
	sed -i "s|#define LUA_CDIR[[:space:]]*LUA_ROOT \"lib/lua/\"|#define LUA_CDIR \"/usr/$(get_libdir)/lua/\"|" \
		src/luaconf.h || die
}

src_compile() {
	local mycflags=(
		${CPPFLAGS}
		${CFLAGS}
		-fPIC
	)
	local syscflags=(
		-DLUA_USE_POSIX
		-DLUA_USE_DLOPEN
	)
	local syslibs=(
		-Wl,-E
		-ldl
	)

	use deprecated && mycflags+=( -DLUA_COMPAT_MATHLIB )
	if use readline; then
		syscflags+=( -DLUA_USE_READLINE )
		syslibs+=( -lreadline )
	fi

	emake -C src generic \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR) rcu" \
		RANLIB="$(tc-getRANLIB)" \
		MYCFLAGS="${mycflags[*]}" \
		MYLDFLAGS="${LDFLAGS}" \
		SYSCFLAGS="${syscflags[*]}" \
		SYSLIBS="${syslibs[*]}"

	pushd src >/dev/null || die
	$(tc-getCC) ${LDFLAGS} -shared \
		-Wl,-soname,liblua${SLOT}.so.0 \
		-o liblua${SLOT}.so.0.0.0 \
		"${LUA_LIB_OBJECTS[@]}" \
		-lm "${syslibs[@]}" || die
	ln -s liblua${SLOT}.so.0.0.0 liblua${SLOT}.so.0 || die
	ln -s liblua${SLOT}.so.0 liblua${SLOT}.so || die
	$(tc-getCC) ${LDFLAGS} -o lua lua.o -L. -llua${SLOT} -lm "${syslibs[@]}" || die
	popd >/dev/null || die
}

src_test() {
	LD_LIBRARY_PATH="${S}/src${LD_LIBRARY_PATH+:${LD_LIBRARY_PATH}}" emake -C src test
}

src_install() {
	local libdir="/usr/$(get_libdir)"

	newbin src/lua lua${SLOT}
	newbin src/luac luac${SLOT}

	insinto /usr/include/lua${SLOT}
	doins "${LUA_HEADERS[@]/#/src/}"

	dolib.so src/liblua${SLOT}.so.0.0.0
	dosym liblua${SLOT}.so.0.0.0 ${libdir}/liblua${SLOT}.so.0
	dosym liblua${SLOT}.so.0 ${libdir}/liblua${SLOT}.so

	cat > "${T}"/lua${SLOT}.pc <<-EOF || die
		version=${PV}
		prefix=${EPREFIX}/usr
		libdir=${EPREFIX}${libdir}
		includedir=\${prefix}/include/lua${SLOT}

		Name: Lua
		Description: An Extensible Extension Language
		Version: \${version}
		Requires:
		Libs: -L\${libdir} -llua${SLOT}
		Libs.private: -lm -ldl
		Cflags: -I\${includedir}
	EOF
	insinto ${libdir}/pkgconfig
	doins "${T}"/lua${SLOT}.pc

	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1

	dodoc README
	docinto html
	dodoc doc/*.css doc/*.html doc/*.png
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	optfeature "Lua support for Emacs" app-emacs/lua-mode
}
