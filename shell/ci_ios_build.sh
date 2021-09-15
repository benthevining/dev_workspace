#!/bin/sh

export BV_CROSSCOMPILE_IOS="TRUE"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

bash $SCRIPT_DIR/ci_build.sh

exit 0