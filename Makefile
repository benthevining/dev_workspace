SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:

.DEFAULT_GOAL := help

THIS_FILE := $(lastword $(MAKEFILE_LIST))

LEMONS := Lemons
LEMONS_SCRIPTS := $(LEMONS)/scripts
LEMONS_TRANSLATION_SCRIPTS := $(LEMONS_SCRIPTS)/translations
LEMONS_MODULES := $(LEMONS)/modules
LEMONS_MAKE_FILES := $(LEMONS)/util/make

include $(LEMONS_MAKE_FILES)/Makefile

.PHONY: $(ALL_PHONY_TARGETS)

PROJECTS := products
PROJECT_DIRS := $(shell find $(PROJECTS) -type d -maxdepth 1 ! -name $(PROJECTS))
SOURCE_FILES := $(shell find $(PROJECT_DIRS) -type f -name "$(SOURCE_FILE_PATTERNS)")
LEMONS_SOURCE_FILES := $(shell find $(LEMONS_MODULES) -type f -name "$(SOURCE_FILE_PATTERNS)")


#####  BUILDING  #####

all: config ## Builds everything
	@echo "Building everything..."
	$(CMAKE_BUILD_COMMAND) $(WRITE_BUILD_LOG)

plugins: config ## Builds all plugins
	@echo "Building all plugins..."
	$(CMAKE_BUILD_COMMAND) --target ALL_PLUGINS $(WRITE_BUILD_LOG)

apps: config ## Builds all apps
	@echo "Building all apps..."
	$(CMAKE_BUILD_COMMAND) --target ALL_APPS $(WRITE_BUILD_LOG)

imogen: config ## Builds Imogen
	@echo "Building Imogen..."
	$(CMAKE_BUILD_COMMAND) --target Imogen_All $(WRITE_BUILD_LOG)

kicklab: config ## Builds Kicklab
	@echo "Building Kicklab..."
	$(CMAKE_BUILD_COMMAND) --target Kicklab_All $(WRITE_BUILD_LOG)

#

config: $(BUILD) ## Runs CMake configuration

# Configures the build
$(BUILD): $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) $(shell find $(LEMONS) -type f -name "$(CMAKE_FILE_PATTERNS)")
	@echo "Configuring cmake..."
	$(CMAKE_CONFIGURE_COMMAND) $(WRITE_CONFIG_LOG)


#####  UTILITIES  #####

propogate: $(LEMONS_SCRIPTS)/propogate_config_files.py ## Propogates configuration files from the Lemons repo outward to all product repos
	@echo "Propogating configuration files..."
	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
	@cd $(LEMONS) && $(MAKE) $@

format: $(LEMONS_SCRIPTS)/run_clang_format.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) ## Runs clang-format
	@echo "Running clang-format..."
	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
	@cd $(LEMONS) && $(MAKE) $@

uth: ## Updates all git submodules to head
	@echo "Updating git submodules..."
	@$(GIT_UTH)

#

clean: ## Cleans the source tree
	@echo "Cleaning workspace..."
	@$(RM) $(BUILD) $(LOGS) $(TRANSLATIONS)
	@for dir in $(PROJECT_DIRS) ; do \
		$(RM) $$dir/$(BUILD) $$dir/$(LOGS) $$dir/assets/translations ; \
	done
	@cd $(LEMONS) && $(MAKE) $@

wipe: clean ## Cleans everything, and busts the CPM cache
	@echo "Wiping workspace cache..."
	@$(RM) $(CACHE)
	@cd $(LEMONS) && $(MAKE) $@

help: ## Prints the list of commands
	@$(PRINT_HELP_LIST)
