cmake_minimum_required (VERSION 3.19)

project (Workspace)

option (BV_WORKSPACE_BUILD "" ON)
option (BV_USE_CCACHE "" ON)

set (ENV{CPM_SOURCE_CACHE} ${CMAKE_CURRENT_LIST_DIR}/Cache)
set (ENV{CCACHE_BASEDIR}   ${CMAKE_CURRENT_LIST_DIR})
set (ENV{CCACHE_DIR}       ${CMAKE_CURRENT_LIST_DIR}/Cache/ccache/cache)

set (CPM_Shared-code_SOURCE ${CMAKE_CURRENT_LIST_DIR}/Shared-code)


add_subdirectory (imogen)
add_subdirectory (kicklab)
add_subdirectory (StageHand)

#add_subdirectory (lab)


include (CPack)