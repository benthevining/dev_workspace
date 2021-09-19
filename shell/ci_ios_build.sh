#!/usr/bin/env bash

set -euo pipefail

export BV_CROSSCOMPILE_IOS="TRUE"

readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

/usr/bin/env bash "$script_dir/ci_build.sh"

exit 0