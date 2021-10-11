#!/usr/bin/env bash

set -euo pipefail

readonly build_config=${BV_BUILD_CONFIG:-release}
readonly build_target=${BV_BUILD_TARGET:-all}

export LEMONS_USE_LV2_JUCE="TRUE"
export LEMONS_COPY_TO_DEPLOY_FOLDER="TRUE"

export BV_COMMIT_TO_REPOS="FALSE"
export BV_DEFAULT_BUILD_CONFIG=$build_config
export BV_DEBUG_RAKE_OUTPUT="FALSE"
export BV_BUILD_EXTRAS="FALSE"

#

readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#

readonly deps_script="$script_dir/../Lemons/scripts/install_deps.sh"

chmod u+x "$deps_script"
bash "$deps_script"

#

cd "$script_dir/.."

display_and_execute_rake_command() {
	printf "\n\n rake $1"
	printf "\n\n"
	rake "$1"

	if [ "$?" -ne "0" ]; then
		echo "Command failed: $1"
	  	exit 1
	fi
}

display_and_execute_rake_command "config[$build_config]"
display_and_execute_rake_command "build:$build_target[$build_config]"

exit 0