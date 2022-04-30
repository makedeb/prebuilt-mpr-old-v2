# Maintainer: Giovanni Ivan Alberotanza <ivan81@disroot.org>

pkgname=betterbird-bin
_pkgname=betterbird
pkgdesc="Betterbird is a fine-tuned version of Mozilla Thunderbird, Thunderbird on steroids, if you will."
pkgrel=1
pkgver=91.8.0
_pkgsubver=29
arch=('x86_64')
url="https://www.betterbird.eu/index.html"
license=('MPL2')
provides=('betterbird')
conflicts=('betterbird')

source=(
        # https://www.betterbird.eu/downloads/get.php?os=linux&lang=en-US&version=release
        "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-$pkgver-bb$_pkgsubver.en-US.linux-x86_64.tar.bz2"
        "betterbird.desktop"
        "betterbird.svg"
      )
sha256sums=('SKIP'
            'SKIP'
            'SKIP')

package() {
    cd "$srcdir"
    mkdir -p "$pkgdir/usr/bin"
    install -d -m755 "$pkgdir/usr/lib/$pkgname"
    install -Dm644 "$_pkgname.desktop" -t "$pkgdir/usr/share/applications"
    cp -r ./betterbird/* "$pkgdir/usr/lib/$pkgname"
    ln -rs "$pkgdir/usr/lib/$pkgname/betterbird" "$pkgdir/usr/bin/betterbird"
    install -D -m644 betterbird.svg "$pkgdir"/usr/share/icons/hicolor/scalable/apps/$_pkgname.svg
}
