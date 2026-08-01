# ═══════════════════════════════════════════════════════════════
# 󰡨 ravn-cli product Docker surface (prefixed targets only)
# ═══════════════════════════════════════════════════════════════

RAVN_CLI_DOCKER_ENV ?= arch
RAVN_CLI_DOCKER_ENVS := arch ubuntu fedora

ifeq ($(filter $(RAVN_CLI_DOCKER_ENV),$(RAVN_CLI_DOCKER_ENVS)),)
$(error Unsupported RAVN_CLI_DOCKER_ENV: $(RAVN_CLI_DOCKER_ENV). Supported values: $(RAVN_CLI_DOCKER_ENVS))
endif

RAVN_CLI_DOCKER_IMAGE_arch := ravn-cli:local
RAVN_CLI_DOCKER_IMAGE_ubuntu := ravn-cli:ubuntu-local
RAVN_CLI_DOCKER_IMAGE_fedora := ravn-cli:fedora-local
RAVN_CLI_DOCKER_ENV_LABEL_arch := Arch Linux
RAVN_CLI_DOCKER_ENV_LABEL_ubuntu := Ubuntu
RAVN_CLI_DOCKER_ENV_LABEL_fedora := Fedora
RAVN_CLI_DOCKERFILE_arch := docker/ravn-cli/Dockerfile
RAVN_CLI_DOCKERFILE_ubuntu := docker/ravn-cli/ubuntu.Dockerfile
RAVN_CLI_DOCKERFILE_fedora := docker/ravn-cli/fedora.Dockerfile
RAVN_CLI_DOCKER_IMAGE ?= $(RAVN_CLI_DOCKER_IMAGE_$(RAVN_CLI_DOCKER_ENV))
RAVN_CLI_DOCKER_ENV_LABEL := $(RAVN_CLI_DOCKER_ENV_LABEL_$(RAVN_CLI_DOCKER_ENV))
RAVN_CLI_DOCKERFILE := $(RAVN_CLI_DOCKERFILE_$(RAVN_CLI_DOCKER_ENV))
RAVN_CLI_DOCKER_TEST_IMAGES := ravn-cli:local ravn-cli:ubuntu-local ravn-cli:fedora-local

.PHONY: help-ravn-cli-docker ravn-cli-docker-build ravn-cli-docker-run ravn-cli-docker-clean ravn-cli-docker-clean-all

help-ravn-cli-docker: ## Show ravn-cli product Docker targets
	@printf "\n"
	@printf "$(CYAN)ravn-cli Docker targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make ravn-cli-docker-build RAVN_CLI_DOCKER_ENV=arch|ubuntu|fedora\n"
	@printf "                              Build the selected product image\n"
	@printf "  make ravn-cli-docker-run RAVN_CLI_DOCKER_ENV=arch|ubuntu|fedora\n"
	@printf "                              Start an interactive, ephemeral product container\n"
	@printf "  make ravn-cli-docker-clean RAVN_CLI_DOCKER_ENV=arch|ubuntu|fedora\n"
	@printf "                              Remove the selected product image\n"
	@printf "  make ravn-cli-docker-clean-all\n"
	@printf "                              Remove all local ravn-cli test images\n"
	@printf "\n"

ravn-cli-docker-build: ## Build the ravn-cli product Docker image
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@docker build --file "$(RAVN_CLI_DOCKERFILE)" --tag "$(RAVN_CLI_DOCKER_IMAGE)" .

ravn-cli-docker-run: ## Run ravn-cli interactively in an ephemeral container
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@$(MAKE) --no-print-directory ravn-cli-docker-build
	@printf "\n"
	@printf "$(CYAN)󰡨  ravn-cli · ephemeral Docker trial$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  $(DIM)Isolated container — your local home directory is not mounted.$(NC)\n"
	@printf "  $(DIM)Phase 1 construction stubs only; no live Git/SSH/GPG setup.$(NC)\n"
	@printf "\n"
	@printf "  $(BLUE)▸$(NC) Starting ravn-cli in $(CYAN)$(RAVN_CLI_DOCKER_ENV_LABEL)$(NC)...\n"
	@printf "\n"
	@docker run --rm -it --env RAVN_CLI_DOCKER_TRIAL=1 "$(RAVN_CLI_DOCKER_IMAGE)"; status=$$?; \
	printf "\n"; \
	printf "  $(GREEN)✓$(NC) Ephemeral container removed. Local host unchanged.\n"; \
	printf "\n"; \
	exit $$status

ravn-cli-docker-clean: ## Remove the selected ravn-cli Docker image
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@case " $(RAVN_CLI_DOCKER_TEST_IMAGES) " in \
	*" $(RAVN_CLI_DOCKER_IMAGE) "*) ;; \
	*) printf "$(RED)Refusing to remove unmanaged Docker image: $(RAVN_CLI_DOCKER_IMAGE)$(NC)\n"; exit 1;; \
	esac
	@if docker image inspect "$(RAVN_CLI_DOCKER_IMAGE)" > /dev/null 2>&1; then \
	  docker image rm "$(RAVN_CLI_DOCKER_IMAGE)"; \
	else \
	  printf "$(GREEN)No local Docker image to remove$(NC)\n"; \
	fi

ravn-cli-docker-clean-all: ## Remove all local ravn-cli Docker test images
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@for image in $(RAVN_CLI_DOCKER_TEST_IMAGES); do \
	  if docker image inspect "$$image" > /dev/null 2>&1; then \
	    docker image rm "$$image"; \
	  else \
	    printf "$(GREEN)No local Docker image to remove: $$image$(NC)\n"; \
	  fi; \
	done
