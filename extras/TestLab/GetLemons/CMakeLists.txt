include (get_lemons.cmake)

set (source_dir "${CMAKE_CURRENT_LIST_DIR}/../Source")

lemons_add_juce_modules ("${source_dir}/modules")

set (LEMONS_PROJECT_SOURCE_DIR "${source_dir}" PARENT_SCOPE)