SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:

.DEFAULT_GOAL := help

THIS_FILE := $(lastword $(MAKEFILE_LIST))

LEMONS := Lemons
LEMONS_SCRIPTS := $(LEMONS)/scripts
LEMONS_MODULES := $(LEMONS)/modules
LEMONS_MAKE_FILES := $(LEMONS)/util/make

QC := plugin_qc

include $(LEMONS_MAKE_FILES)/Makefile

.PHONY: $(ALL_PHONY_TARGETS)

PROJECTS := products
PROJECT_DIRS := $(shell find $(PROJECTS) -type d -maxdepth 1 ! -name $(PROJECTS))
SOURCE_FILES := $(shell find $(PROJECT_DIRS) -type f -name "$(SOURCE_FILE_PATTERNS)")
LEMONS_SOURCE_FILES := $(shell find $(LEMONS_MODULES) -type f -name "$(SOURCE_FILE_PATTERNS)")


#####  BUILDING  #####

all: config ## Builds everything
	@echo "Building everything..."
	time $(CMAKE_BUILD_COMMAND) 2>&1 | tee $(BUILD_LOG_FILE)

plugins: config ## Builds all plugins
	@echo "Building all plugins..."
	time $(CMAKE_BUILD_COMMAND) --target ALL_PLUGINS | tee $(BUILD_LOG_FILE)

apps: config ## Builds all apps
	@echo "Building all apps..."
	time $(CMAKE_BUILD_COMMAND) --target ALL_APPS | tee $(BUILD_LOG_FILE)

imogen: config ## Builds Imogen
	@echo "Building Imogen..."
	time $(CMAKE_BUILD_COMMAND) --target Imogen_All | tee $(BUILD_LOG_FILE)

kicklab: config ## Builds Kicklab
	@echo "Building Kicklab..."
	time $(CMAKE_BUILD_COMMAND) --target Kicklab_All | tee $(BUILD_LOG_FILE)

#

config: $(BUILD) ## Runs CMake configuration

# Configures the build
$(BUILD): $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) $(shell find $(LEMONS) -type f -name "$(CMAKE_FILE_PATTERNS)")
	@echo "Configuring cmake..."
	$(CMAKE_CONFIGURE_COMMAND)


#####  QC  #####

qc: all ## Builds the QC suite
	cd $(QC) && $(MAKE) all


#####  UTILITIES  #####

format: $(LEMONS_SCRIPTS)/run_clang_format.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) ## Runs clang-format
	@echo "Running clang-format..."
	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
	cd $(LEMONS) && $(MAKE) $@

uth: ## Updates all git submodules to head
	@echo "Updating git submodules..."
	$(GIT_UTH)

translations: $(LEMONS_SCRIPTS)/generate_translation_file.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) ## Generates JUCE translation files for Lemons and for each project
	@echo "Generating translation files..."
	@for dir in $(PROJECT_DIRS) ; do cd $$dir && $(PYTHON) $< Source $(TRANSLATION_OUTPUT) ; done
	cd $(LEMONS) && $(MAKE) $@

clean: ## Cleans the source tree
	@echo "Cleaning workspace..."
	@$(RM) $(BUILD) $(CONFIG_LOG_FILE) $(BUILD_LOG_FILE)
	@for dir in $(PROJECT_DIRS) ; do $(RM) $$dir/$(TRANSLATION_OUTPUT) ; done
	cd $(LEMONS) && $(MAKE) $@
	cd $(QC) && $(MAKE) $@

wipe: clean ## Cleans everything, and busts the CPM cache
	@echo "Wiping workspace cache..."
	@$(RM) $(CACHE)

help: ## Prints the list of commands
	@$(PRINT_HELP_LIST)
