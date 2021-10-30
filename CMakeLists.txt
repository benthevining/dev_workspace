cmake_minimum_required (VERSION 3.21 FATAL_ERROR)

project (Workspace)


set (CPM_Lemons_SOURCE "${CMAKE_CURRENT_LIST_DIR}/Lemons")

option (LEMONS_BUILD_TESTS "Build the Lemons unit tests" OFF)

if (LEMONS_BUILD_TESTS)
	enable_testing()
endif()

add_subdirectory (PrivateSDKs)

add_subdirectory (products)
