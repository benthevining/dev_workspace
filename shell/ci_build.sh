#!/bin/bash


BUILD_CONFIG=${BV_BUILD_CONFIG:-release}
BUILD_TARGET=${BV_BUILD_TARGET:-all}

export BV_COMMIT_TO_REPOS="FALSE"
export BV_DEFAULT_BUILD_CONFIG=$BUILD_CONFIG
export BV_IGNORE_CCACHE="FALSE"
export BV_COPY_TO_DEPLOY_FOLDER="TRUE"

export BV_USE_LV2_JUCE="TRUE"
export BV_DEBUG_RAKE_OUTPUT="FALSE"

#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR/..

#

display_and_execute_rake_command() {
	printf "\n\n rake $1"
	printf "\n\n"
	rake $1
}

SKIPPING_INIT=${BV_SKIP_INIT:-FALSE}

if ! [ "$SKIPPING_INIT" = "TRUE" ] ; then 
	display_and_execute_rake_command "init"
fi

display_and_execute_rake_command "config[$BUILD_CONFIG]"
display_and_execute_rake_command "build:$BUILD_TARGET[$BUILD_CONFIG]"

exit 0