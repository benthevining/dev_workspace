cmake_minimum_required (VERSION 3.17)

project (Workspace)

set (ENV{CPM_SOURCE_CACHE} ${CMAKE_CURRENT_LIST_DIR}/Cache)

set (CPM_Shared-code_SOURCE ${CMAKE_CURRENT_LIST_DIR}/Shared-code)

add_subdirectory (imogen)
add_subdirectory (kicklab)
add_subdirectory (StageHand)
