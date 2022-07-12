# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=zoxide
pkgver=0.8.2
pkgrel=1
pkgdesc='A smarter cd command.'
arch=('any')
makedepends=(
    'cargo'
    'findutils'
)

source=("${pkgname}-${pkgver}::git+https://github.com/ajeetdsouza/zoxide/#tag=v${pkgver}")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release --all-features
}

package() {
    cd "${pkgname}-${pkgver}/"

    install -Dm 755 "target/release/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
    install -Dm 644 "contrib/completions/${pkgname}.bash" "${pkgdir}/usr/share/bash-completion/completions/${pkgname}"
    install -Dm 644 -t "${pkgdir}/usr/share/man/man1/" man/man1/*
}

# vim: set sw=4 expandtab:
