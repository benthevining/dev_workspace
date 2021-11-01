SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:

.DEFAULT_GOAL := help

THIS_FILE := $(lastword $(MAKEFILE_LIST))
THIS_DIR := $(abspath $(dir $(THIS_FILE)))

LEMONS := Lemons
LEMONS_SCRIPTS := $(LEMONS)/scripts

include $(LEMONS)/util/make/Makefile

.PHONY: $(ALL_PHONY_TARGETS)

PROJECT_DIRS := $(shell find products -maxdepth 1 -type d ! -name products)


#####  BUILDING  #####

all: Builds/default ## Builds everything
	@echo "Building everything..."
	cmake --build --preset all -j $(NUM_CORES)

ios: Builds/ios ## Builds everything for iOS
	@echo "Building everything for iOS..."
	cmake --build --preset ios -j $(NUM_CORES)

plugins: Builds/default ## Builds all plugins
	@echo "Building all plugins..."
	cmake --build --preset all --target ALL_PLUGINS -j $(NUM_CORES)

apps: Builds/default ## Builds all apps
	@echo "Building all apps..."
	cmake --build --preset all --target ALL_APPS -j $(NUM_CORES)

imogen: Builds/default ## Builds Imogen
	@echo "Building Imogen..."
	cmake --build --preset all --target Imogen_ALL -j $(NUM_CORES)

imogen_remote: Builds/default ## Builds Imogen Remote
	@echo "Building Imogen Remote..."
	cmake --build --preset all --target ImogenRemote -j $(NUM_CORES)

kicklab: Builds/default ## Builds Kicklab
	@echo "Building Kicklab..."
	cmake --build --preset all --target Kicklab_ALL -j $(NUM_CORES)

build_tests: Builds/tests ## Builds all tests
	@echo "Building tests..."
	cmake --build --preset tests -j $(NUM_CORES)


#####  CMAKE CONFIGURATION  #####

config: Builds/default ## Runs CMake configuration

Builds/default:
	@echo "Configuring cmake..."
	cmake --preset default -G $(CMAKE_GENERATOR)

Builds/ios:
	@echo "Configuring cmake..."
	cmake --preset ios

Builds/tests:
	@echo "Configuring cmake..."
	cmake --preset tests -G $(CMAKE_GENERATOR)


# TESTING

tests: build_tests ## Builds and runs all unit tests
	@echo "Running tests..."
	ctest --preset all


#####  UTILITIES  #####

# propogate: $(LEMONS_SCRIPTS)/project_config/propogate_config_files.py ## Propogates configuration files from the Lemons repo outward to all product repos
# 	@echo "Propogating configuration files..."
# 	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
# 	@cd $(LEMONS) && $(MAKE) $@

# format: $(LEMONS_SCRIPTS)/run_clang_format.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) ## Runs clang-format
# 	@echo "Running clang-format..."
# 	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
# 	@cd $(LEMONS) && $(MAKE) $@

uth: ## Updates all git submodules to head
	@echo "Updating git submodules..."
	@$(GIT_UTH)

#

clean: ## Cleans the source tree
	@echo "Cleaning workspace..."
	@$(RM) Builds logs Testing
	@for dir in $(PROJECT_DIRS) ; do \
		$(RM) $$dir/Builds $$dir/logs ; \
	done
	@cd $(LEMONS) && $(MAKE) $@

wipe: clean ## Cleans everything, and busts the CPM cache
	@echo "Wiping workspace cache..."
	@$(RM) Cache
	cd $(LEMONS) && $(MAKE) $@

help: ## Prints the list of commands
	@$(PRINT_HELP_LIST)
