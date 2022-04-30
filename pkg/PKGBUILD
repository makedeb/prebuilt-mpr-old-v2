# Maintainer: Nirenjan Krishnan <nirenjan@gmail.com>

pkgname=libx52
_gitname=x52pro-linux
pkgver=0.2.3_4_gb45dc59
pkgrel=1
pkgdesc="Application to control the MFD and LEDs of a Saitek X52/X52Pro HOTAS"
arch=('x86_64')
url="https://github.com/nirenjan/x52pro-linux"
license=('GPL2')
depends=('libusb-1.0-0' 'libhidapi-hidraw0' 'libevdev2')
makedepends=('autoconf' 'automake' 'libtool' 'pkg-config' 'python3'
         'gettext' 'autopoint' 'libusb-1.0-0-dev' 'libhidapi-dev'
         'libevdev-dev' 'doxygen' 'rsync' 'libcmocka-dev' 'git')
source=("git+https://github.com/nirenjan/x52pro-linux.git")
sha256sums=('SKIP')

pkgver() {
  cd ${srcdir}/${_gitname}
  git describe | cut -c2- | tr - _
}

prepare() {
  cd ${srcdir}/${_gitname}
  # nothing to see here
}

build() {
  cd ${srcdir}/${_gitname}
  ./autogen.sh
  ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc \
    --disable-silent-rules --disable-maintainer-mode
  make
}

package() {
  cd ${srcdir}/${_gitname}

  make install DESTDIR="$pkgdir"
}
