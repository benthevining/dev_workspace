cmake_minimum_required (VERSION 3.19)

project (Workspace)


option (LEMONS_WORKSPACE_BUILD "" ON)

set (LEMONS_TOPLEVEL_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "" FORCE)

set (ENV{CPM_SOURCE_CACHE} ${CMAKE_CURRENT_LIST_DIR}/Cache)
set (CPM_Lemons_SOURCE ${CMAKE_CURRENT_LIST_DIR}/Lemons)

set (LEMONS_CCACHE_OPTIONS "CCACHE_BASEDIR=${CMAKE_CURRENT_LIST_DIR}")
list (APPEND LEMONS_CCACHE_OPTIONS "CCACHE_DIR=${CMAKE_CURRENT_LIST_DIR}/Cache/ccache/cache")


add_subdirectory (PrivateSDKs)

add_subdirectory (products)


include (CPack)
