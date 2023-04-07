## TODO
##@ General
# 
##@ Development

ALL_PLATFORMS ?= $(shell go tool dist list | grep -E 'linux|windows|darwin' | grep -E 'amd64|arm64')

VERSION ?= $(shell git describe --tags --always --dirty)

BIN_EXTENSION :=
ifeq ($(OS), windows)
  BIN_EXTENSION := .exe
endif

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


.PHONY: test
TEST_ARGS ?= -v
TEST_TARGETS ?= ./...
test: ## Test the Go modules within this package.
	@ echo "go test $(TEST_ARGS) $(TEST_TARGETS)"
	go test $(TEST_ARGS) $(TEST_TARGETS)

.PHONY: lint
LINT_TARGETS ?= ./...
lint: ## Lint Go code with the golint
	@ echo "gollint"
	golint $(LINT_TARGETS)

build-%:
	$(MAKE) build                         \
	    --no-print-directory              \
	    GOOS=$(firstword $(subst _, ,$*)) \
	    GOARCH=$(lastword $(subst _, ,$*))

.PHONY: all-build 
all-build: ## builds binaries for all platforms
	$(addprefix build-, $(subst /,_, $(ALL_PLATFORMS)))