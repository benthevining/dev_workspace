#!/usr/bin/env bash

set -euo pipefail

export LEMONS_USE_LV2_JUCE="TRUE"
export LEMONS_COPY_TO_DEPLOY_FOLDER="TRUE"

readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

readonly workspace_root="$script_dir/.."

/usr/bin/env bash "$workspace_root/Lemons/install_deps/install_deps.sh"

cd "$workspace_root"

make all

exit 0