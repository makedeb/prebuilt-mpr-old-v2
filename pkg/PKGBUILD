# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
_release=stable
_target=mpr

pkgname=makedeb
pkgver=16.0.0
pkgrel=stable
pkgdesc="A simplicity-focused packaging tool for Debian archives"
arch=('all')
license=('GPL3')
depends=(
	'apt'
	'binutils'
	'build-essential'
	'curl'
	'fakeroot'
	'file'
	'gettext'
	'gawk'
	'libarchive-tools'
	'lsb-release'
	'python3'
	'python3-apt'
	'zstd'
)
makedepends=(
	'asciidoctor'
	'git'
	'make'
	'jq'
)
url="https://github.com/makedeb/makedeb"

source=("makedeb::git+${url}/#tag=v${pkgver}-${pkgrel}")
sha256sums=('SKIP')

prepare() {
	cd makedeb/
	make prepare PKGVER="${pkgver}" RELEASE="${_release}" TARGET="${_target}" CURRENT_VERSION="${pkgver}-${pkgrel}"
}

package() {
	cd makedeb/
	make package DESTDIR="${pkgdir}" TARGET="${_target}"
}
