# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=bitwarden-bin
pkgver=2022.8.1
pkgrel=1
pkgdesc='A secure and free password manager for all of your devices.'
arch=('amd64')
depends=('libnotify4' 'libxtst6' 'libnss3' 'libsecret-1-0' 'libxss1')
license=('GPL-3.0')
url="https://bitwarden.com"

source=("https://github.com/bitwarden/clients/releases/download/desktop-v${pkgver}/Bitwarden-${pkgver}-amd64.deb")
sha256sums=('SKIP')

package() {
  msg2 "Extracting data.tar.xz..."
  tar -xf 'data.tar.xz' -C "${pkgdir}"
}
