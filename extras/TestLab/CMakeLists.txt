cmake_minimum_required (VERSION 3.19) 

project (TestLab VERSION 0.0.1 LANGUAGES CXX) 

add_subdirectory (GetLemons)

option (LEMONS_WORKSPACE_BUILD "" OFF)

macro (add_product name repourl)
        if (NOT LEMONS_WORKSPACE_BUILD)
                CPMAddPackage (
                        NAME ${name}
                        GIT_REPOSITORY https://github.com/benthevining/${repourl}.git
                        GIT_TAG origin/main)
        endif()
endmacro()

add_product (Imogen imogen)
add_product (Kicklab kicklab)


juce_add_gui_app (TestLab 
	        ${BV_DEFAULT_BRAND_FLAGS}
		MICROPHONE_PERMISSION_ENABLED   TRUE
		NEEDS_MIDI_INPUT            	TRUE)

lemons_configure_juce_app (TARGET TestLab PLUGIN_HOST)

target_sources (TestLab PRIVATE ${LEMONS_PROJECT_SOURCE_DIR}/main.cpp)

target_include_directories (TestLab PRIVATE ${LEMONS_PROJECT_SOURCE_DIR})

target_link_libraries (TestLab PRIVATE bv_lab_graph bv_lab_gui imogen_gui kicklab_gui)
