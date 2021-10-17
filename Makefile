SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
	
.DEFAULT_GOAL := help
.PHONY: all imogen kicklab clean config defaults docs format help translations uth wipe

LEMONS := Lemons
LEMONS_MAKE_FILES := $(LEMONS)/util/make
LEMONS_SCRIPTS := $(LEMONS)/scripts
LEMONS_MODULES := $(LEMONS)/modules

include $(LEMONS_MAKE_FILES)/basic_settings.make

PROJECTS := products
PROJECT_DIRS := $(shell find $(PROJECTS) -type d)
SOURCE_FILES := $(shell find $(PROJECT_DIRS) -type f -name "$(SOURCE_FILE_PATTERNS)")
LEMONS_SOURCE_FILES := $(shell find $(LEMONS_MODULES) -type f -name "$(SOURCE_FILE_PATTERNS)")

include $(LEMONS_MAKE_FILES)/cmake.make

#

all: config ## Builds everything
	@echo "Building everything..."
	$(CMAKE_BUILD_COMMAND)

imogen: config ## Builds Imogen
	@echo "Building Imogen..."
	$(CMAKE_BUILD_COMMAND) --target Imogen_All

kicklab: config ## Builds Kicklab
	@echo "Building Kicklab..."
	$(CMAKE_BUILD_COMMAND) --target Kicklab_All

#

config: $(BUILD) ## Runs CMake configuration

# Configures the build
$(BUILD): $(SOURCE_FILES) $(LEMONS_SOURCE_FILES) $(shell find $(LEMONS) -type f -name "*.cmake|*CMakeLists.txt")
	@echo "Configuring cmake..."
	$(CMAKE_CONFIGURE_COMMAND)

#

format: $(TEMP)/format ## Runs clang-format

# Executes clang-format
$(TEMP)/format: $(LEMONS_SCRIPTS)/run_clang_format.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES)
	@echo "Running clang-format..."
	@mkdir -p $(@D)
	@for dir in $(PROJECT_DIRS) ; do $(PYTHON) $< $$dir ; done
	cd $(LEMONS) && $(MAKE) format
	@touch $@

#

uth: ## Updates all git submodules to head
	@echo "Updating git submodules..."
	$(GIT_UTH)

#

translations: $(TEMP)/translations ## Generates JUCE translation files for Lemons and for each project

# Executes the translation file generation
$(TEMP)/translations: $(LEMONS_SCRIPTS)/generate_translation_file.py $(SOURCE_FILES) $(LEMONS_SOURCE_FILES)
	@echo "Generating translation files..."
	@mkdir -p $(@D)
	@for dir in $(PROJECT_DIRS) ; do cd $$dir && $(PYTHON) $< Source $(TRANSLATION_OUTPUT) ; done
	cd $(LEMONS) && $(MAKE) translations
	@touch $@

#

clean: ## Cleans the source tree
	@echo "Cleaning workspace..."
	rm -rf $(BUILD) $(TEMP) $(PLUGINVAL_REPO)/$(BUILD)
	@for dir in $(PROJECT_DIRS) ; do rm -rf $(PROJECTS)/$$dir/$(TRANSLATION_OUTPUT) ; done
	cd $(LEMONS) && $(MAKE) clean

wipe: clean ## Cleans everything, and busts the CPM cache
	@echo "Wiping workspace cache..."
	rm -rf $(CACHE)

help: ## Prints the list of commands
	@$(PRINT_HELP_LIST)
