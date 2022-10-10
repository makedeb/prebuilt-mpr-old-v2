# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=hyperfine
pkgver=1.15.0
pkgrel=1
pkgdesc='A command-line benchmarking tool'
arch=('any')
makedepends=('cargo' 'rustc>=1.57')
url='https://github.com/sharkdp/hyperfine'

source=("${pkgname}-${pkgver}::git+${url}/#tag=v${pkgver}")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 target/release/hyperfine "${pkgdir}/usr/bin/hyperfine"
    install -Dm 644 target/release/build/hyperfine-*/out/hyperfine.bash "${pkgdir}/usr/share/bash-completion/completions/hyperfine"
    install -Dm 644 doc/hyperfine.1 "${pkgdir}/usr/share/man/man1/hyperfine.1"
}

# vim: set sw=4 expandtab:
