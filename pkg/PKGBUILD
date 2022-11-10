# Maintainer: hiddeninthesand <hiddeninthesand at pm dot me>

# AUR Maintainer: Morten Linderud <foxboron@archlinux.org>
# AUR Maintainer: Caleb Maclennan <caleb@alerque.com>
# AUR Contributor: Eli Schwartz <eschwartz@archlinux.org>
# AUR Contributor: Richard Bradfield <bradfier@fstab.me>

pkgname="gh"
_gitname="cli"
pkgver='2.20.0'
pkgrel='1'
pkgdesc="The GitHub CLI"
arch=("any")
url="https://github.com/cli/cli"
license=("MIT")
depends=("libc6-dev")
makedepends=("golang-go" "git" "build-essential")
optdepends=("git: To interact with repositories")
source=("git+${url}.git#tag=v${pkgver}")
sha256sums=('SKIP')
conflicts=("gh-git" "gh-bin")

prepare() {
    cd "${_gitname}"
    # TODO: These tests invoke the TTY and our container *really* does not like that
    rm pkg/cmd/auth/login/login_test.go
}

build() {
    cd "${_gitname}"

    export CGO_CPPFLAGS="${CPPFLAGS}"
    export CGO_CFLAGS="${CFLAGS}"
    export CGO_CXXFLAGS="${CXXFLAGS}"
    export CGO_LDFLAGS="${LDFLAGS}"
    export CGO_ENABLED=0
    export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw -ldflags=-linkmode=external"

    make GH_VERSION="v${pkgver}" bin/gh manpages
    bin/gh completion -s bash | install -Dm644 /dev/stdin share/bash-completion/completions/gh
    bin/gh completion -s zsh | install -Dm644 /dev/stdin share/zsh/site-functions/_gh
    bin/gh completion -s fish | install -Dm644 /dev/stdin share/fish/vendor_completions.d/gh.fish
}

check(){
    cd "${_gitname}"
    make test
}

package() {
    cd "${_gitname}"
    make DESTDIR="${pkgdir}" prefix="/usr" install
    cp -r share/ "$pkgdir"/usr
    install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 "README.md" "$pkgdir/usr/share/doc/$pkgname/README.md"
}
