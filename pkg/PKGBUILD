# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=mcrcon
pkgver=0.7.2
pkgrel=1
pkgdesc='Rcon client for Minecraft'
arch=('any')
license=('Zlib')
url='https://github.com/Tiiffi/mcrcon'

source=("${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    make
}

package() {
    cd "${pkgname}-${pkgver}/"
    make install PREFIX="${pkgdir}/usr"
}

# vim: set sw=4 expandtab:
