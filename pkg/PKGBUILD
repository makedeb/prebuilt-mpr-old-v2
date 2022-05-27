# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
export GIT_LFS_SKIP_SMUDGE=1 # Prevents Git LFS errors during clone.

pkgname=airshipper
pkgver=0.7.0
pkgrel=1
pkgdesc='The official launcher for Veloren - an open-world, open-source multiplayer voxel RPG'
arch=('any')
makedepends=(
    'cargo'
    'git'
    'git-lfs'
    'libxkbcommon-dev'
)
url='https://gitlab.com/veloren/airshipper'

source=("${pkgname}-${pkgver}::git+${url}/#tag=v${pkgver}")
sha256sums=('SKIP')

prepare() {
    unset GIT_LFS_SKIP_SMUDGE # Unset GIT_LFS_SKIP_SMUDGE now that we've cloned.

    cd "${pkgname}-${pkgver}/"
    git remote set-url origin "${url}"
    git lfs install
    git lfs fetch
    git lfs checkout
}

build() {
    cd "${pkgname}-${pkgver}/"
    cargo build --release --all-features -p airshipper
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 target/release/airshipper "${pkgdir}/usr/bin/airshipper"
    install -Dm 644 client/assets/net.veloren.airshipper.png "${pkgdir}/usr/share/icons/hicolor/256x256/apps/net.veloren.airshipper.png"
    install -Dm 644 client/assets/net.veloren.airshipper.desktop "${pkgdir}/usr/share/applications/net.veloren.airshipper.desktop"
}

# vim: set sw=4 expandtab:
