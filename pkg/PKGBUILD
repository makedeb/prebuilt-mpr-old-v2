# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=deno
pkgver=1.25.0
pkgrel=1
pkgdesc='A modern runtime for JavaScript and TypeScript'
arch=('any')
makedepends=('cargo' 'git')
url='https://deno.land'
license=('MIT')

source=("${pkgname}-${pkgver}::git+https://github.com/denoland/deno/#tag=v${pkgver}")
sha256sums=('SKIP')

prepare() {
    cd "${pkgname}-${pkgver}/"
    git submodule update --init --recursive
}

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 "target/release/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
    "${pkgdir}/usr/bin/${pkgname}" completions bash | install -Dm 644 /dev/stdin "${pkgdir}/usr/share/bash-completion/completions/${pkgname}"
}

# vim: set sw=4 expandtab:
