.DEFAULT_GOAL := help

DOTFILES_DIR := .

RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
CYAN := \033[0;36m
DIM := \033[2m
NC := \033[0m

include make/git.mk
include make/docker.mk
include make/aliases.mk
include make/hooks.mk
include make/quality.mk
include make/release.mk
include make/ravn-cli/git.mk
include make/ravn-cli/docker.mk
include make/ravn-cli/aliases.mk

.PHONY: help
help: help-git help-docker help-aliases help-hooks help-quality help-release help-ravn-cli-git help-ravn-cli-docker help-ravn-cli-aliases
