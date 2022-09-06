# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=sentry-cli
pkgver=2.5.2
pkgrel=1
pkgdesc='A command line utility to work with Sentry.'
arch=('any')
makedepends=('cargo' 'cmake')
license=('BSD-3')
url='https://docs.sentry.io/cli'

source=("https://github.com/getsentry/sentry-cli/archive/refs/tags/${pkgver}.tar.gz")
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
