# Maintainer: only_vip <onlyme_vip@protonmail.com>
# Contributor: Tux <tux@hardwaretisch.de>
pkgname=polybar
pkgver=3.6.3
pkgrel=1
pkgdesc="A fast and easy-to-use status bar"
arch=("i686" "amd64")
url="https://github.com/polybar/polybar"
license=("MIT")
depends=('libasound2' 'libatomic1' 'libc6' 'libcairo2' 'libcurl4' 'libfontconfig1' 'libfreetype6' 'libgcc-s1' 'libmpdclient2' 'libnl-3-200' 'libpulse0' 'libstdc++6' 'libxcb-composite0' 'libxcb-cursor0' 'libxcb-ewmh2' 'libxcb-icccm4' 'libxcb-image0' 'libxcb-randr0-dev' 'libxcb-xkb1' 'libxcb-xrm0' 'libxcb1')
bullseye_depends=(${depends[@]} 'libjsoncpp24')
bookworm_depends=(${depends[@]} 'libjsoncpp24')
focal_depends=(${depends[@]} 'libjsoncpp1')
groovy_depends=(${depends[@]} 'libjsoncpp1')
hirsute_depends=(${depends[@]} 'libjsoncpp24')
impish_depends=(${depends[@]} 'libjsoncpp24')
makedepends=('cmake' 'cmake-data' 'libcairo2-dev' 'libxcb1-dev' 'libxcb-ewmh-dev' 'libxcb-icccm4-dev' 'libxcb-image0-dev' 'libxcb-randr0-dev' 'libxcb-util0-dev' 'libxcb-xkb-dev' 'pkg-config' 'python3-xcbgen' 'xcb-proto' 'libxcb-xrm-dev' 'i3-wm' 'libasound2-dev' 'libmpdclient-dev' 'libiw-dev' 'libcurl4-openssl-dev' 'libpulse-dev' 'libjsoncpp-dev' 'python3-sphinx' 'python3-packaging' 'libxcb-composite0-dev' 'asciidoc' 'docbook' 'docbook2x' 'libpulse-dev' 'libuv1-dev')
optdepends=('ttf-unifont' 'i3-wm' 'i3-gaps-git' 'siji-git')
provides=('polybar')
conflicts=('polybar')
source=("${url}/releases/download/${pkgver}/${pkgname}-${pkgver}.tar.gz")
sha512sums=("SKIP")
_dir="${pkgname}-${pkgver}"
MAKEFLAGS="-j$(nproc)"

build() {
	install -d "${_dir}/build"
	cd ${_dir}/build || exit 1
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ..
	cmake build .
}

package() {
	cmake --build "${_dir}/build" --target install -- DESTDIR="${pkgdir}"
  	install -Dm644 "${_dir}/LICENSE" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
