SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:

.DEFAULT_GOAL := help

THIS_FILE := $(lastword $(MAKEFILE_LIST))

LEMONS := Lemons
LEMONS_SCRIPTS := $(LEMONS)/scripts
LEMONS_MODULES := $(LEMONS)/modules

include $(LEMONS)/util/make/Makefile
include make/Makefile

.PHONY: $(ALL_PHONY_TARGETS)

PROJECT_DIRS := $(shell find products -type d -maxdepth 1 ! -name products)
SOURCE_FILES := $(shell find $(PROJECT_DIRS) -type f -name "$(SOURCE_FILE_PATTERNS)")
LEMONS_SOURCE_FILES := $(shell find $(LEMONS_MODULES) -type f -name "$(SOURCE_FILE_PATTERNS)")


#####  BUILDING  #####

all: config ## Builds everything
	@echo "Building everything..."
	$(CMAKE_BUILD_COMMAND)

plugins: config ## Builds all plugins
	@echo "Building all plugins..."
	$(CMAKE_BUILD_CMD_PREFIX) $@ $(CMAKE_BUILD_CMD_SUFFIX)

apps: config ## Builds all apps
	@echo "Building all apps..."
	$(CMAKE_BUILD_CMD_PREFIX) $@ $(CMAKE_BUILD_CMD_SUFFIX)

imogen: config ## Builds Imogen
	@echo "Building Imogen..."
	$(CMAKE_BUILD_CMD_PREFIX) $@ $(CMAKE_BUILD_CMD_SUFFIX)

imogen_remote: config ## Builds Imogen Remote
	@echo "Building Imogen Remote..."
	$(CMAKE_BUILD_CMD_PREFIX) $@ $(CMAKE_BUILD_CMD_SUFFIX)

kicklab: config ## Builds Kicklab
	@echo "Building Kicklab..."
	$(CMAKE_BUILD_CMD_PREFIX) $@ $(CMAKE_BUILD_CMD_SUFFIX)

#

config: Builds ## Runs CMake configuration

Builds: $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) $(shell find $(LEMONS) -type f -name "$(CMAKE_FILE_PATTERNS)")
	@echo "Configuring cmake..."
	$(CMAKE_CONFIGURE_COMMAND) $(WRITE_CONFIG_LOG)

#

# TESTING

tests: build_tests ## Builds and runs all unit tests
	@echo "Running tests..."
	ctest --preset all

build_tests: configure_tests
	$(CMAKE_BUILD_CMD_PREFIX) tests $(CMAKE_BUILD_CMD_SUFFIX)

configure_tests:
	@$(MAKE) config TESTS=1

.PHONY: configure_tests build_tests

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
	@$(RM) Builds logs Testing/
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
