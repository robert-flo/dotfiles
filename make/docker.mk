# ═══════════════════════════════════════════════════════════════
# 󰡨 DOCKER - Interactive local package preview
# ═══════════════════════════════════════════════════════════════

DOCKER_ENV ?= arch
DOCKER_ENVS := arch ubuntu fedora

ifeq ($(filter $(DOCKER_ENV),$(DOCKER_ENVS)),)
$(error Unsupported DOCKER_ENV: $(DOCKER_ENV). Supported values: $(DOCKER_ENVS))
endif

DOCKER_IMAGE_arch := dotfiles:local
DOCKER_IMAGE_ubuntu := dotfiles:ubuntu-local
DOCKER_IMAGE_fedora := dotfiles:fedora-local
DOCKERFILE_arch := Dockerfile
DOCKERFILE_ubuntu := docker/ubuntu.Dockerfile
DOCKERFILE_fedora := docker/fedora.Dockerfile
DOCKER_IMAGE ?= $(DOCKER_IMAGE_$(DOCKER_ENV))
DOCKERFILE := $(DOCKERFILE_$(DOCKER_ENV))
DOCKER_TEST_IMAGES := dotfiles:local dotfiles:ubuntu-local dotfiles:fedora-local

.PHONY: help-docker docker-build docker-run docker-clean docker-clean-all

help-docker: ## Show Docker targets
	@printf "\n"
	@printf "$(CYAN)Docker targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make docker-build DOCKER_ENV=arch|ubuntu|fedora\n"
	@printf "                              Build the selected local image\n"
	@printf "  make docker-run DOCKER_ENV=arch|ubuntu|fedora\n"
	@printf "                              Start the selected interactive, ephemeral container\n"
	@printf "  make docker-clean DOCKER_ENV=arch|ubuntu|fedora\n"
	@printf "                              Remove the selected local image\n"
	@printf "  make docker-clean-all      Remove all local dotfiles test images\n"
	@printf "\n"

docker-build: ## Build the local Docker image
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@test -f "$(DOCKERFILE)" || { printf "$(RED)Dockerfile not found: $(DOCKERFILE)$(NC)\n"; exit 1; }
	@docker build --file "$(DOCKERFILE)" --tag "$(DOCKER_IMAGE)" .

docker-run: ## Run dotfiles interactively in an ephemeral container
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@if ! docker image inspect "$(DOCKER_IMAGE)" > /dev/null 2>&1; then \
		$(MAKE) --no-print-directory docker-build; \
	fi
	@docker run --rm -it "$(DOCKER_IMAGE)"

docker-clean: ## Remove the local Docker image
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@case " $(DOCKER_TEST_IMAGES) " in \
		*" $(DOCKER_IMAGE) "*) ;; \
		*) printf "$(RED)Refusing to remove unmanaged Docker image: $(DOCKER_IMAGE)$(NC)\n"; exit 1;; \
	esac
	@if docker image inspect "$(DOCKER_IMAGE)" > /dev/null 2>&1; then \
		docker image rm "$(DOCKER_IMAGE)"; \
	else \
		printf "$(GREEN)No local Docker image to remove$(NC)\n"; \
	fi

docker-clean-all: ## Remove all local Docker test images
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@for image in $(DOCKER_TEST_IMAGES); do \
		if docker image inspect "$$image" > /dev/null 2>&1; then \
			docker image rm "$$image"; \
		else \
			printf "$(GREEN)No local Docker image to remove: $$image$(NC)\n"; \
		fi; \
	done
