SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
.PHONY: all imogen kicklab clean config defaults docs format help translations uth wipe

#

PYTHON := python

PROJECTS := products
PROJECT_DIRS := $(shell find $(PROJECTS) -type d)

SOURCE_FILE_PATTERNS := *.h|*.cpp|*CMakeLists.txt

SOURCE_FILES := $(shell find $(PROJECT_DIRS) -type f -name "$(SOURCE_FILE_PATTERNS)")

TEMP = .out
CACHE := Cache

LEMONS := Lemons
LEMONS_SCRIPTS := $(LEMONS)/scripts
LEMONS_MODULES := $(LEMONS)/modules
LEMONS_SOURCE_FILES := $(shell find $(LEMONS_MODULES) -type f -name "$(SOURCE_FILE_PATTERNS)")
LEMONS_CMAKE_FILES := $(shell find $(LEMONS) -type f -name "*.cmake|*CMakeLists.txt")

include $(LEMONS)/cmake/Makefile

#

all: $(TEMP)/$(BUILD)/all ## Builds everything

# Executes the all build
$(TEMP)/$(BUILD)/all: config
	@echo "Building everything..."
	@mkdir -p $(@D)
	$(CMAKE_BUILD_COMMAND)
	@touch $@

imogen: $(TEMP)/$(BUILD)/imogen ## Builds Imogen

$(TEMP)/$(BUILD)/imogen: config
	@echo "Building Imogen..."
	@mkdir -p $(@D)
	$(CMAKE_BUILD_COMMAND) --target Imogen_All
	@touch $@

kicklab: $(TEMP)/$(BUILD)/kicklab ## Builds Kicklab

$(TEMP)/$(BUILD)/kicklab: config
	@echo "Building Kicklab..."
	@mkdir -p $(@D)
	$(CMAKE_BUILD_COMMAND) --target Kicklab_All
	@touch $@

#

config: $(BUILD) ## Runs CMake configuration

# Configures the build
$(BUILD): $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) $(LEMONS_CMAKE_FILES)
	@echo "Configuring cmake..."
	$(CMAKE_CONFIGURE_COMMAND)

#

FORMAT_SENTINEL := $(TEMP)/format

format: $(FORMAT_SENTINEL) ## Runs clang-format

# Executes clang-format
$(FORMAT_SENTINEL): $(LEMONS_SCRIPTS)/run_clang_format.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES)
	@echo "Running clang-format..."
	@mkdir -p $(@D)
	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
	cd $(LEMONS) && $(MAKE) format
	@touch $@

#

SUBMODULE_COMMAND := git checkout main && git fetch && git pull

uth: ## Updates all git submodules to head
	@echo "Updating git submodules..."
	git fetch && git pull
	git submodule update
	git submodule foreach '$(SUBMODULE_COMMAND)'

#

TRANSLATION_OUTPUT := needed_translations.txt

TRANSLATION_SENTINEL := $(TEMP)/translations

translations: $(TRANSLATION_SENTINEL) ## Generates JUCE translation files for Lemons and for each project

# Executes the translation file generation
$(TRANSLATION_SENTINEL): $(LEMONS_SCRIPTS)/generate_translation_file.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES)
	@echo "Generating translation files..."
	@mkdir -p $(@D)
	@for dir in $(PROJECT_DIRS) ; do cd $$dir && $(PYTHON) $< Source $(TRANSLATION_OUTPUT) ; done
	cd $(LEMONS) && $(MAKE) translations
	@touch $@

######

# TESTING #

PLUGINVAL_REPO := $(CACHE)/pluginval

# Clones the pluginval repo to the cache
$(PLUGINVAL_REPO): 
	@echo "Cloning pluginval repo..."
	cd $(CACHE) && git clone https://github.com/Tracktion/pluginval.git
	cd $(PLUGINVAL_REPO) && git submodule init && git fetch && git pull

PLUGINVAL_APP := $(PLUGINVAL_REPO)/$(BUILD)/pluginval_artefacts/$(BUILD_TYPE)/pluginval.app

# Builds pluginval from source
$(PLUGINVAL_APP): $(PLUGINVAL_REPO)
	@echo "Configuring pluginval build..."
	cd $(PLUGINVAL_REPO) && $(CMAKE_CONFIGURE_COMMAND)
	@echo "Running plugival build..."
	cd $(PLUGINVAL_REPO) && $(CMAKE_BUILD_COMMAND)

pluginval: $(PLUGINVAL_APP) ## Builds pluginval from source

######

clean: ## Cleans the source tree
	@echo "Cleaning workspace..."
	rm -rf $(BUILD) $(TEMP) $(PLUGINVAL_REPO)/$(BUILD)
	@for dir in $(PROJECT_DIRS) ; do rm -rf $(PROJECTS)/$$dir/$(TRANSLATION_OUTPUT) ; done
	cd $(LEMONS) && $(MAKE) clean

wipe: clean ## Cleans everything, and busts the CPM cache
	@echo "Wiping workspace cache..."
	rm -rf $(CACHE)

help: ## Prints the list of commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
