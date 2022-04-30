# Maintainer: thesting <fxcw_vacilon@slmail.me>
pkgname=k9s-bin
_pkgname=k9s
pkgver=0.25.18
pkgrel=1
pkgdesc="Kubernetes CLI To Manage Your Clusters In Style!"
arch=('x86_64')
license=('Apache-2.0')
depends=()
makedepends=()
url="https://github.com/derailed/k9s"
provides=('k9s')
conflicts=('k9s')

source=(
  https://github.com/derailed/k9s/releases/download/v${pkgver}/k9s_Linux_x86_64.tar.gz
)
sha512sums=(
  a9e1edf3c1ee658a381bd6fb47de5481682099813cdd6b9c1d99049c8f0c7c765534af2a76837ac0331af9c0f8ce6ef4ec93a9f5220cd58837e132f62172b245
)

pkgver() {
  # When you curl to latest it returns a redirect to the version
  VER=$(curl -s https://github.com/derailed/k9s/releases/latest | egrep "You are being " | egrep -o "v[0-9]\.[0-9]*\.[0-9]*" | cut -d 'v' -f 2)
  printf $VER
}

package() {
  install -Dm755 "k9s" "$pkgdir/usr/local/bin/k9s"
}
