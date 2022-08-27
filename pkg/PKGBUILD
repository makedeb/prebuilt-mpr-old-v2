# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
_pkgname='node'
pkgname=nodejs
pkgver=18.8.0
pkgrel=2
pkgdesc='Node.js JavaScript runtime'
arch=('any')
depends=(
    'libbrotli-dev'
    'libc-ares-dev'
    'libnghttp2-dev'
    'libuv1-dev'
    'libssl-dev'
    'zlib1g-dev'
)
makedepends=(
    'g++'
    'ninja-build'
    'python3'
)
url='https://nodejs.org'

source=("https://github.com/nodejs/${_pkgname}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${_pkgname}-${pkgver}/"
    ./configure \
        --prefix=/usr \
        --without-npm \
        --ninja \
        --shared-brotli \
        --shared-cares \
        --shared-nghttp2 \
        --shared-libuv \
        --shared-openssl \
        --shared-zlib

    make
}

package() {
    cd "${_pkgname}-${pkgver}/"
    make DESTDIR="${pkgdir}" install
    "${pkgdir}/usr/bin/${_pkgname}" --completion-bash | install -Dm 644 /dev/stdin "${pkgdir}/usr/share/bash-completion/completions/${_pkgname}"

    (
        PATH="${pkgdir}/usr/bin:${PATH}"
        "${pkgdir}/usr/bin/corepack" enable --install-directory "${pkgdir}/usr/bin"
    )
}

# vim: set sw=4 expandtab:
