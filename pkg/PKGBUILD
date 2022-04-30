#!/usr/bin/env bash
# -- vim: filetype=sh syntax=sh softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 smartindent autoindent expandtab
# Maintainer: alfador <contact@havi.dev>
pkgname="synergy-git"
pkgver=1.14.3.3.r0+gbf102d460
pkgrel=1
pkgdesc='Open source core of Synergy, the keyboard and mouse sharing tool'
arch=('i686' 'x86_64' 'arm' 'armv6h' 'armv7h' 'aarch64')
license=('GPL2')
depends=(
  'xorg-dev'
  'libnotify-dev'
)
makedepends=(
  'git'
  'qtcreator'
  'qttools5-dev'
  'cmake'
  'make'
  'g++'
  'libssl-dev'
  'libx11-dev'
  'libsodium-dev'
  'libgl1-mesa-glx'
  'libegl1-mesa'
  'libcurl4-openssl-dev'
  'libavahi-compat-libdnssd-dev'
  'qtdeclarative5-dev'
  'libqt5svg5-dev'
  'libsystemd-dev'
  'libgdk-pixbuf2.0-dev'
  'libglib2.0-dev'
)
optdepends=('qtbase5-dev: gui support')
url='https://symless.com/synergy'
license=('GPL2')
source=(
  "${pkgname%-git}::git+https://github.com/symless/synergy-core"
  'synergys.service'
  'synergys.socket'
)
sha512sums=(
  'SKIP'
  'e85cc3452bb8ba8fcccb1857386c77eb1e4cabb149a1c492c56b38e1b121ac0e7d96c6fcbd3c9b522d3a4ae9d7a9974f4a89fc32b02a56f665be92af219e371c'
  'f9c124533dfd0bbbb1b5036b7f4b06f7f86f69165e88b9146ff17798377119eb9f1a4666f3b2ee9840bc436558d715cdbfe2fdfd7624348fae64871f785a1a62'
)
provides=("${pkgname%-git}")
conflicts=("${pkgname%-git}")
postinst=post.install
# ──────────────────────────────────────────────────────────────────────
pkgver() {
  git -C "${srcdir}/${pkgname%-git}" \
    describe --long --tags |
    sed 's/\([^-]*\)-g/r\1+g/;s/-snapshot-/./g'
}
# ──────────────────────────────────────────────────────────────────────
prepare() {
  msg2 "${pkgname%-git} : Pulling and updating git submodules"
  git -C "${srcdir}/${pkgname%-git}" submodule sync --recursive
  git -C "${srcdir}/${pkgname%-git}" submodule update --init --force --recursive
  msg2 'Preparing directories'
  rm -rf "${srcdir}/${pkgname%-git}/build"
  mkdir -p "${srcdir}/${pkgname%-git}/build"
}
build() {
  cd "${srcdir}/${pkgname%-git}/build" || exit 1
  cmake -G "Unix Makefiles" \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DOPENSSL_USE_STATIC_LIBS="true" \
    -DSYNERGY_ENTERPRISE="${SYNERGE_ENTERPRISE:-ON}" \
    ..
  make --no-print-directory -j"$(nproc)"
}
check() {
  cd "${srcdir}/${pkgname%-git}/build" || exit 1
  msg2 "Running unit tests ..."
  bin/unittests
}
# [ FIXME ] `synergyc` and `synergys` reference
# "${srcdir}/src/lib/net/SecureSocket.cpp". Explore and see if this causes any
# issues and if it does , what are potential ways to fix this.
package() {
  cd "${srcdir}/${pkgname%-git}/build" || exit 1
  # ──────────────────────────────────────────────────────────────────────
  msg2 "Installing built artifacts ..."
  DESTDIR="${pkgdir}" make --no-print-directory -j"$(nproc)" install
  # ──────────────────────────────────────────────────────────────────────
  cd "${srcdir}/${pkgname%-git}" || exit 1
  msg2 "Install configuration files ..."
  install -Dm644 doc/*.conf.* -t "$pkgdir/usr/share/doc/synergy"
  # ──────────────────────────────────────────────────────────────────────
  msg2 "Install manfiles, documents and license"
  install -Dm644 "doc/synergyc.man" "${pkgdir}/usr/share/man/man1/synergyc.1"
  install -Dm644 "doc/synergys.man" "${pkgdir}/usr/share/man/man1/synergys.1"
  install -Dm644 "LICENSE" "${pkgdir}/usr/share/doc/${pkgname%-git}/copyright"
  install -Dm644 "README.md" "${pkgdir}/usr/share/doc/${pkgname%-git}/README.md"
}
# ─── REFRENCES ──────────────────────────────────────────────────────────────────
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=synergy-git
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=barrier-git
# https://github.com/symless/synergy-core/wiki/Compiling
# ────────────────────────────────────────────────────────────────────────────────
