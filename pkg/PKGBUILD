# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=tokei
pkgver=12.1.2
pkgrel=2
pkgdesc='Count your code, quickly'
arch=('any')
makedepends=('cargo')
license=('MIT' 'Apache-2.0')
url='https://github.com/XAMPPRocky/tokei'

source=("${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release --all-features
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 "target/release/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
}

# vim: set sw=4 expandtab:
