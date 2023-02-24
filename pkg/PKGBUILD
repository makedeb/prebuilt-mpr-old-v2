# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=xtr
pkgver=0.1.6
pkgrel=1
pkgdesc="Extract strings from a rust crate to be translated with gettext"
arch=('any')
makedepends=('cargo')
license=('AGPL-3.0')
url='https://github.com/woboq/tr#about-xtr'

source=("https://github.com/woboq/tr/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "tr-${pkgver}/"
    cargo build --bin "${pkgname}" --release
}

package() {
    cd "tr-${pkgver}/"
    install -Dm 755 "target/release/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
}

# vim: set sw=4 expandtab: