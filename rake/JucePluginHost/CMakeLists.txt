cmake_minimum_required (VERSION 3.19)

project (JucePluginHost VERSION 0.0.1)


set (RepoRoot ${CMAKE_CURRENT_LIST_DIR}/../..)

set (ENV{CPM_SOURCE_CACHE} ${RepoRoot}/Cache)


add_subdirectory (${RepoRoot}/Shared-code ${CMAKE_CURRENT_LIST_DIR}/Builds/Shared-code)

add_subdirectory (${JUCE_SOURCE_DIR}/extras/AudioPluginHost ${CMAKE_CURRENT_LIST_DIR}/Builds/PluginHost)