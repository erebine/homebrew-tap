# Xerotier Homebrew tap Makefile

TAG ?=

.PHONY: update
update: ## Pin formulas and cask to the latest stable release
	TAG="$(TAG)" scripts/update-formulas.sh

.DEFAULT_GOAL := update
