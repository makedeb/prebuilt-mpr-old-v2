# Maintainer: dada513 <dada513@protonmail.com>
# Contributor: Sefa Eyeoglu <conctact@scrumplex.net>

pkgname=prismlauncher
pkgver=5.0
pkgrel=3
pkgdesc="Minecraft launcher with ability to manage multiple instances."
arch=('i686' 'amd64')
url="https://prismlauncher.org"
license=('GPL3')
depends=('libqt5svg5' 'qt5-image-formats-plugins' 'libqt5xml5' 'libqt5core5a' 'libqt5network5' 'libqt5gui5')
makedepends=('scdoc' 'extra-cmake-modules' 'cmake' 'git' 'openjdk-17-jdk' 'zlib1g-dev' 'libgl1-mesa-dev' 'qtbase5-dev' 'qtchooser' 'qt5-qmake' 'qtbase5-dev-tools' 'gcc' 'g++')
optdepends=('java-runtime=8: support for Minecraft versions < 1.17'
            'java-runtime=17: support for Minecraft versions >= 1.17')	    
conflicts=('polymc')
source=("https://github.com/PrismLauncher/PrismLauncher/releases/download/$pkgver/PrismLauncher-$pkgver.tar.gz")
sha256sums=("27c2c7e0c9aaa3450b7449683cfd2a9a941b7118ab83947de09285438e03c495")

build() {
  cd "${srcdir}/PrismLauncher-$pkgver"
  mkdir -p build
  cd build
  cmake -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    -DLauncher_BUILD_PLATFORM="debian" \
    -DLauncher_APP_BINARY_NAME="${pkgname}" \
    -DENABLE_LTO=ON \
    ..
  cmake --build .
}

check() {
  cd "${srcdir}/PrismLauncher-$pkgver/build"
  ctest .
}

package() {
  cd "${srcdir}/PrismLauncher-$pkgver/build"
  DESTDIR="$pkgdir" cmake --install .
}

