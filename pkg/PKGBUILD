# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=exa
pkgver=0.10.1
pkgrel=1
pkgdesc="A modern replacement for 'ls'"
arch=('any')
makedepends=('cargo' 'pandoc' 'libgit2-dev' 'cmake')
license=('MIT')
url='https://the.exa.website'

source=("${pkgname}-${pkgver}::git+https://github.com/ogham/exa/#tag=v${pkgver}")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 target/release/exa "${pkgdir}/usr/bin/exa"
    pandoc --standalone -f markdown -t man man/exa.1.md | install -Dm 644 /dev/stdin "${pkgdir}/usr/share/man/man1/exa.1"
    pandoc --standalone -f markdown -t man man/exa_colors.5.md | install -Dm 644 /dev/stdin "${pkgdir}/usr/share/man/man5/exa_colors.5"
    install -Dm 644 completions/completions.bash "${pkgdir}/usr/share/bash-completion/completions/exa"
}

# vim: set sw=4 expandtab:
