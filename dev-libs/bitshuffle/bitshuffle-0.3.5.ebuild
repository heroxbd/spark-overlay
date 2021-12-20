# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Bitshuffle C library"
HOMEPAGE="https://github.com/kiyo-masui/bitshuffle"
SRC_URI="https://github.com/kiyo-masui/bitshuffle/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/lz4
"

src_prepare() {
	cp "${FILESDIR}/${P}-Makefile" "Makefile" || die "Failed to copy Makefile"
	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	local prefix="${EPREFIX}/usr"
	emake \
		DESTDIR="${D}" \
		PREFIX="${prefix}" \
		LIBDIR="${prefix}/$(get_libdir)" \
		install
}
