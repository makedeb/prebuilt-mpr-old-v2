# vim: filetype=make syntax=make textwidth=0 softtabstop=0 tabstop=4 shiftwidth=4 fileencoding=utf-8 smartindent autoindent noexpandtab
#  ────────────────────────────────────────────────────────────────────
SHELL=/bin/bash
.PHONY: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
.SILENT: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
.PHONY: all
all: help
--apt-update:
	sudo apt-get update
#  ────────────────────────────────────────────────────────────────────
help: ## Show this help
	@printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n"

clean:
	rm -rf  src pkg *.deb *.tar.gz eternal-terminal

srcinfo: ## Generate srcinfo
	makedeb --printsrcinfo > .SRCINFO

makedeb: ## Build the package while syncing dependencies
	makedeb --sync-deps --no-confirm

install:build  ## Installs the package
	makedeb --install --no-confirm
commit-prep: clean srcinfo ## prepares the package for commiting. only valid when used in the Docker container
	find /workspace-git -mindepth 1 -maxdepth 1 -not -path '**/\.git' -delete \
	&& find /workspace -mindepth 1 -maxdepth 1 -not -path '**/\.git' -exec cp -r {} /workspace-git/ \; 
commit: VERSION = $(shell grep pkgver .SRCINFO | cut -d '=' -f 2 | tr -d '[:space:]')
commit: commit-prep ## Commits changes to git
	git -C "/workspace-git" add PKGBUILD Makefile *.install .SRCINFO .gitignore
	git -C "/workspace-git" commit -m "feat: Update to ${VERSION}"


build: --apt-update srcinfo makedeb ## Main target for building a fresh package