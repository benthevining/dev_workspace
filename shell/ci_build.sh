#!/bin/sh

################

BUILD_CONFIG="release"

export BV_COMMIT_TO_REPOS="false"
export BV_DEFAULT_BUILD_CONFIG=$BUILD_CONFIG

################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR/..

################

rake init

rake "config[$BUILD_CONFIG]"

rake "build:all[$BUILD_CONFIG]"

exit 0