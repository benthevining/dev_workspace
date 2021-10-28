CMAKE_CONFIG_CMD := cmake -G "$(CMAKE_GENERATOR)" -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

ifdef CROSSCOMPILE_IOS
	CMAKE_CONFIG_PRESET := config_ios
	CMAKE_BUILD_PRESET := all_ios
else 
	ifdef TESTS
		CMAKE_CONFIG_PRESET := config_tests
	else
		CMAKE_CONFIG_PRESET := config
	endif
endif

CMAKE_CONFIG_CMD += --preset $(CMAKE_CONFIG_PRESET)

# This is the configure command actually referenced by makefiles
CMAKE_CONFIGURE_COMMAND := mkdir $(LOGS) && time $(CMAKE_CONFIG_CMD) $(WRITE_CONFIG_LOG)

#

CMAKE_BUILD_CMD_PREFIX := time cmake --build --preset

CMAKE_BUILD_CMD_SUFFIX := --config $(BUILD_TYPE) -j $(NUM_CORES) $(WRITE_BUILD_LOG)

CMAKE_BUILD_COMMAND := $(CMAKE_BUILD_CMD_PREFIX) all $(CMAKE_BUILD_CMD_SUFFIX)
