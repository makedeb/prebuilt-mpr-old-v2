# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=docuum
pkgver=0.21.1
pkgrel=1
pkgdesc='Perform least recently used (LRU) eviction of Docker images'
arch=('any')
depends=('docker.io>=17.03.0')
makedepends=('cargo')
url='https://github.com/stepchowfun/docuum'

source=(
    "${url}/archive/refs/tags/v${pkgver}.tar.gz"
    "${pkgname}.service"
)
sha256sums=(
    'SKIP'
    'SKIP'
)

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release
}

package() {
    install -Dm 644 "${pkgname}.service" "${pkgdir}/lib/systemd/system/${pkgname}.service"

    cd "${pkgname}-${pkgver}/"
    install -Dm 755 "target/release/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
}

# vim: set sw=4 expandtab:
