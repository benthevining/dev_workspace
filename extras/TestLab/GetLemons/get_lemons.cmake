#  Adds the Lemons package (via CPM, which this also installs)
#


include_guard (GLOBAL)

include (get_cpm.cmake)

CPMAddPackage (
        NAME Lemons
        GIT_REPOSITORY https://github.com/benthevining/Lemons.git
        GIT_TAG origin/main)