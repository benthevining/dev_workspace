cmake_minimum_required (VERSION 3.19)

project (JucePluginHost VERSION 0.0.1)

if (NOT DEFINED BV_REPO_ROOT)
	set (BV_REPO_ROOT ${CMAKE_CURRENT_LIST_DIR}/../..)
endif()

set (ENV{CPM_SOURCE_CACHE} ${BV_REPO_ROOT}/Cache)

add_subdirectory (${BV_REPO_ROOT}/Shared-code ${CMAKE_BINARY_DIR}/Shared-code)

add_subdirectory (${JUCE_SOURCE_DIR}/extras/AudioPluginHost ${CMAKE_BINARY_DIR}/PluginHost)