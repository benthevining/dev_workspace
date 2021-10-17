SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
.PHONY: clean defaults docs format help uth

#

PROJECT_DIRS := $(shell find products -type d)

SOURCE_FILES := $(shell find $(PROJECT_DIRS) -type f -name "*.h|*.cpp|*CMakeLists.txt")

BUILD_TYPE := Debug

ifeq ($(OS),Windows_NT)
	CMAKE_GENERATOR := Visual Studio 16 2019
else
	UNAME_S := $(shell uname -s)

	ifeq ($(UNAME_S),Linux)
		CMAKE_GENERATOR := Unix Makefiles
	else ifeq ($(UNAME_S),Darwin)
		CMAKE_GENERATOR := Xcode
	else 
		$(error Unknown operating system!)
	endif
endif

#

all: .out/Build ## Builds everything

.out/Build: Builds
	@echo "Building..."
	@mkdir -p $(@D)
	cmake --build Builds --config $(BUILD_TYPE)
	@touch $@

# Configures the build
Builds: $(SOURCE_FILES) 
	@echo "Configuring cmake..."
	cmake -B Builds -G "$(CMAKE_GENERATOR)" -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

#

format: .out/format ## Runs clang-format

.out/format: Lemons/scripts/run_clang_format.py $(SOURCE_FILES)
	@echo "Running clang-format..."
	@mkdir -p $(@D)

	for dir in $(PROJECT_DIRS) ; do \
		python $< $$dir ; \
	done

	cd Lemons && $(MAKE) format

	@touch $@

#

SUBMODULE_COMMAND := git checkout main && git fetch && git pull

uth: ## Updates all git submodules to head
	@echo "Updating git submodules..."
	git fetch && git pull
	git submodule update
	git submodule foreach '$(SUBMODULE_COMMAND)'

#

clean: ## Cleans the source tree
	rm -rf Builds
	cd Lemons && $(MAKE) clean

help: ## Prints the list of commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'