# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=ripgrep
pkgver=13.0.0
pkgrel=1
pkgdesc='Recursively search directories for a regex pattern, while respecting your gitignore'
arch=('any')
makedepends=(
    'rustc>=1.34.0'
    'cargo'
    'asciidoctor'
    'pkg-config'
)
license=('MIT' 'UNLICENSE')
url='https://github.com/BurntSushi/ripgrep'

source=("${pkgname}-${pkgver}::git+${url}/#tag=${pkgver}")
sha256sums=('SKIP')

build() {
    true
    cd "${pkgname}-${pkgver}/"
    cargo build --release --features 'pcre2'
}

package() {
    cd "${pkgname}-${pkgver}/"
    install -Dm 755 target/release/rg "${pkgdir}/usr/bin/rg"
    find target/release/build -name 'rg.bash' -exec install -Dm 644 '{}' "${pkgdir}/usr/share/bash-completion/completions/rg" \;
    find target/release/build -name 'rg.1' -exec install -Dm 644 '{}' "${pkgdir}/usr/share/man/man1/rg.1" \;
}

# vim: set sw=4 expandtab:
