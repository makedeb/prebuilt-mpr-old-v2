# vim: filetype=make syntax=make textwidth=0 softtabstop=0 tabstop=4 shiftwidth=4 fileencoding=utf-8 fileformat=unix smartindent autoindent noexpandtab
#  ────────────────────────────────────────────────────────────────────
.PHONY: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
.SILENT: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
.PHONY: all
all: help
#  ────────────────────────────────────────────────────────────────────
help: ## Show this help
	@printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n"

clean:
	rm -rf src go pkg *.deb *.tar.gz

srcinfo: ## Generate srcinfo
	makedeb --printsrcinfo > .SRCINFO

makedeb: ## Build the package while syncing dependencies
	makedeb -sr --no-confirm

commit-prep: clean srcinfo ## prepares the package for commiting. only valid when used in the Docker container
	find /workspace-git -mindepth 1 -maxdepth 1 -not -path '**/\.git' -delete \
	&& find /workspace -mindepth 1 -maxdepth 1 -not -path '**/\.git' -exec cp -r {} /workspace-git/ \; 

commit: VERSION = $(shell grep pkgver .SRCINFO | cut -d '=' -f 2 | tr -d '[:space:]')
commit: commit-prep ## Commits changes to git
	git -C "/workspace-git" add PKGBUILD Makefile  .SRCINFO .gitignore
	git -C "/workspace-git" commit -m "feat: Update to ${VERSION}"

--apt-update:
	sudo apt-get update

build: --apt-update srcinfo makedeb ## Main target for building a fresh package

install: build ## Installs the package
	sudo apt-get autoremove -y && sudo dpkg -i go-git*.deb && go version && sudo apt-get autoremove -y 
