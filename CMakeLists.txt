cmake_minimum_required (VERSION 3.19)

project (Workspace)


option (BV_WORKSPACE_BUILD "" ON)

set (ENV{CPM_SOURCE_CACHE} ${CMAKE_CURRENT_LIST_DIR}/Cache)
set (CPM_Shared-code_SOURCE ${CMAKE_CURRENT_LIST_DIR}/Shared-code)

set (BV_CCACHE_OPTIONS "CCACHE_BASEDIR=${CMAKE_CURRENT_LIST_DIR}")
list (APPEND BV_CCACHE_OPTIONS "CCACHE_DIR=${CMAKE_CURRENT_LIST_DIR}/Cache/ccache/cache")


add_subdirectory (PrivateSDKs)

add_subdirectory (imogen)
add_subdirectory (kicklab)
add_subdirectory (StageHand)

#add_subdirectory (lab)


include (CPack)
