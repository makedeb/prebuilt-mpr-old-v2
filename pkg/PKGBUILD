# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=glow
pkgver=1.4.1
pkgrel=1
pkgdesc='A terminal based markdown reader'
arch=('any')
makedepends=('golang-go>=1.13')
url='https://github.com/charmbracelet/glow'

source=("${pkgname}-${pkgver}::git+${url}/#tag=v${pkgver}")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    go build -trimpath -o "${pkgname}-${pkgver}-${MAKEDEB_DPKG_ARCHITECTURE}"
}

package() {
    cd "${pkgname}-${pkgver}"
    install -Dm 755 "${pkgname}-${pkgver}-${MAKEDEB_DPKG_ARCHITECTURE}" "${pkgdir}/usr/bin/${pkgname}"
}

# vim: set sw=4 expandtab
