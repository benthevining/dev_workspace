cmake_minimum_required (VERSION 3.19)

project (Workspace)


option (LEMONS_WORKSPACE_BUILD "" ON)

set (ENV{CPM_SOURCE_CACHE} ${CMAKE_CURRENT_LIST_DIR}/Cache)
set (CPM_Lemons_SOURCE ${CMAKE_CURRENT_LIST_DIR}/Lemons)

set (LEMONS_CCACHE_OPTIONS "CCACHE_BASEDIR=${CMAKE_CURRENT_LIST_DIR}")
#list (APPEND LEMONS_CCACHE_OPTIONS "CCACHE_DIR=${CMAKE_CURRENT_LIST_DIR}/Cache/ccache/cache")


add_subdirectory (extras/PrivateSDKs)

add_subdirectory (products)


option (BV_BUILD_EXTRAS "" OFF)

if (BV_BUILD_EXTRAS)
	add_subdirectory (extras)
endif()

include (CPack)
