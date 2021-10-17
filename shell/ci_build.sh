#!/usr/bin/env bash

set -euo pipefail

readonly build_config=${BV_BUILD_CONFIG:-release}
readonly build_target=${BV_BUILD_TARGET:-all}

export LEMONS_USE_LV2_JUCE="TRUE"
export LEMONS_COPY_TO_DEPLOY_FOLDER="TRUE"

#

readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

/usr/bin/env bash "$script_dir/../Lemons/install_deps/install_deps.sh"

#

cd "$script_dir/.."

make all

exit 0