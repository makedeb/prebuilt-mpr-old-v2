# Maintainer: hiddeninthesand <hiddeninthesand at pm dot me>
# Contributor: zocker_160 <zocker1600 at posteo dot net>
# Contributor: Hunter Wittenborn <hunter@hunterwittenborn.com>

pkgname='discord'
pkgver='0.0.25'
pkgrel='1'
pkgdesc="Chat for Communities and Friends"
arch=('x86_64')
_base_depends=('libc6' 'libasound2' 'libatomic1' 'libgconf-2-4' 'libnotify4' 'libnspr4' 'libnss3' 'libstdc++6' 'libxss1'
                'libxtst6' 'libc++1')
depends=("${_base_depends[@]}" 'libappindicator1')
bullseye_depends=("${_base_depends[@]}" 'libayatana-appindicator1')
url="https://discord.com"
license=('custom')
source=("${pkgname}::https://dl.discordapp.net/apps/linux/${pkgver}/discord-${pkgver}.deb")
b2sums=('8a64ecebc98fe1c66903f14ca17ab036c26f11ed8a83b3ab4ab2645ef9a084b76a001c5246989674064b01056c7ea0845139152bfac71db3b360a01b6909050c')

package() {
    tar -xf 'data.tar.gz' -C "${pkgdir}"
    mkdir -p "${pkgdir}/DEBIAN"
    tar -xf 'control.tar.gz' -C "${pkgdir}/DEBIAN"
    rm "${pkgdir}/DEBIAN/control"
}
