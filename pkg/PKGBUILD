# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=drone-runner-exec
pkgver=1.0.0
pkgrel=1
pkgdesc='Execute Drone CI pipelines directly on a host machine'
arch=('any')
makedepends=(
    'git'
    'golang-go'
)
license=(
    'Polyform-Small-Business-1.0.0'
    'Polyform-Free-Trial-1.0.0'
)
backup=(
    '/etc/systemd/system/drone-runner-exec.service'
)
url='https://docs.drone.io/runner/exec/overview'

source=(
    "${pkgname}-${pkgver}::git+https://github.com/drone-runners/drone-runner-exec/#tag=v${pkgver}-beta.9"
    'drone-runner-exec.service'
)
sha256sums=(
    'SKIP'
    'SKIP'
)

build() {
    cd "${pkgname}-${pkgver}/"
    go build -trimpath -o "${pkgname}"
}

package() {
    install -Dm 755 "${pkgname}-${pkgver}/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
    install -Dm 644 drone-runner-exec.service "${pkgdir}/etc/systemd/system/drone-runner-exec.service"
}
# vim: set sw=4 expandtab:
