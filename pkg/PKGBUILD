# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=appimage-builder
pkgver=1.1.0
pkgrel=2
pkgdesc='GNU/Linux packaging solution using the AppImage format'
arch=('amd64')
depends=('libfuse2')
license=('MIT')
extensions=()
url='https://appimage-builder.readthedocs.io/'

source=("https://github.com/AppImageCrafters/appimage-builder/releases/download/v${pkgver}/appimage-builder-${pkgver}-x86_64.AppImage")
sha256sums=('4b4f99cae9291d78ba12dbdabca7c0a67c72aa61eb2e5d424089171a9485e96f')

build() {
    chmod +x "${pkgname}-${pkgver}-x86_64.AppImage"
    "./${pkgname}-${pkgver}-x86_64.AppImage" --appimage-extract
}

package() {
    cd squashfs-root/
    mkdir -p "${pkgdir}/opt/${pkgname}" "${pkgdir}/usr/bin"
    find ./ -mindepth 1 -maxdepth 1 -exec cp -r '{}' "${pkgdir}/opt/${pkgname}/{}" \;
    ln -s "/opt/${pkgname}/AppRun" "${pkgdir}/usr/bin/${pkgname}"
}

# vim: set sw=4 expandtab:
