#
#  Either uses a previously-downloaded version of the CPM.cmake script OR downloads it from GitHub 
#  After you run this once, every subsequent configuration will use the cached CPM script. You can manually delete it to update to a newer version, as CMake will then download the latest version when the next configuration is invoked.
#


include_guard (GLOBAL)

if (ENV{CPM_SOURCE_CACHE})
    set (LEMONS_CPM_PATH $ENV{CPM_SOURCE_CACHE}/CPM.cmake)
else()
    set (LEMONS_CPM_PATH ${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)
endif()

if (NOT EXISTS ${LEMONS_CPM_PATH})
    message (STATUS "Downloading CPM.cmake to ${LEMONS_CPM_PATH}")

    file (DOWNLOAD
      https://raw.githubusercontent.com/cpm-cmake/CPM.cmake/master/cmake/CPM.cmake
      ${LEMONS_CPM_PATH})
endif()

include (${LEMONS_CPM_PATH})
