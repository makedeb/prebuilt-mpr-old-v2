# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=bats
pkgver=1.9.0
pkgrel=1
pkgdesc='Bash Automated Testing System'
arch=('all')
preinst=bats.preinst
license=('MIT')
url='https://bats-core.readthedocs.io/'

source=(
    "${pkgname}-${pkgver}::git+https://github.com/bats-core/bats-core/#tag=v${pkgver}"
    "${pkgname}.profile"
)
sha256sums=(
    'SKIP'
    'SKIP'
)

package() {
	cd "${srcdir}/"
	"./${pkgname}-${pkgver}/install.sh" "${pkgdir}/usr"
        install -Dm 644 "./${pkgname}.profile" "${pkgdir}/etc/profile.d/${pkgname}.profile"
}

# vim: set sw=4 expandtab:
