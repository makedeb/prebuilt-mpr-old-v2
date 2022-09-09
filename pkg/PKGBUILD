# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=dasel
pkgver=1.26.1
pkgrel=1
pkgdesc='Select, put and delete data from JSON, TOML, YAML, XML and CSV files with a single tool'
arch=('any')
makedepends=('golang-go')
license=('MIT')
url='https://daseldocs.tomwright.me'

source=("https://github.com/TomWright/dasel/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}/"
    go build -o "${pkgname}" -ldflags="-X 'github.com/tomwright/dasel/internal.Version=v${pkgver}'" ./cmd/dasel
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 "./${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
    "./${pkgname}" completion bash | install -Dm 644 /dev/stdin "${pkgdir}/usr/share/bash-completion/completions/${pkgname}"
}

# vim: set sw=4 expandtab:
