# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>

pkgname=archlinux-wallpaper
pkgver=1.6.1
pkgrel=1
pkgdesc="Arch Linux Wallpapers"
arch=('any')
url="https://bbs.archlinux.org/viewtopic.php?id=259604"
license=('CC0' 'SPL')
options=('!strip')

source=("https://github.com/xyproto/archlinux-wallpaper/archive/refs/tags/${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
	cd "${pkgname}-${pkgver}"

	install -Dm 666 -t "${pkgdir}/usr/share/backgrounds/archlinux/" img/*.{png,jpg}
	install -Dm 666 -t "${pkgdir}/usr/share/gnome-background-properties/" arch-backgrounds.xml
}
