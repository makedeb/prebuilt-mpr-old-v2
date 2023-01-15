# Maintainer: hiddeninthesand <hiddeninthesand at pm dot me>

# Contributor: Hunter Wittenborn <hunter@hunterwittenborn.com>

pkgname='code-bin'
pkgver='1.74.3'
pkgrel='1'
pkgdesc="Code editing. Redefined."
arch=('x86_64')
depends=('libnss3>=2:3.26' 'gnupg' 'apt' 'libxkbfile1' 'libsecret-1-0' 'libgtk-3-0>=3.10.0' 'libxss1' 'libgbm1')
provides=('visual-studio-code')
_base_url='code.visualstudio.com'
url="https://${_base_url}"

source=("code-${pkgver}.deb::https://update.${_base_url}/${pkgver}/linux-deb-x64/stable")
b2sums=('ed513f28df016690684565cc8b440588e664ad0da6ff4abf251df20c6bb1f8394bc3cd712c33be2cb25bfc3ccab2ac072037e1ab875c86ee6323c61eba6f946c')

package() {
  msg2 "Extracting data.tar.xz..."
  tar -xf data.tar.xz -C "${pkgdir}"

  msg2 "Setting up symlink to /usr/bin/code..."
  mkdir -p "${pkgdir}/usr/bin/"
  ln -s "/usr/share/code/bin/code" "${pkgdir}/usr/bin/code"
}
