# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=mprocs
pkgver=0.6.3
pkgrel=1
pkgdesc='Run multiple commands in parallel'
arch=('any')
depends=('cargo')
license=('MIT')
url='https://github.com/pvolok/mprocs'

source=("${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 "target/release/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
}

# vim: set sw=4 expandtab:
