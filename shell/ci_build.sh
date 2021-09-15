#!/bin/sh

BUILD_CONFIG="release"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

rake init

rake "config[$BUILD_CONFIG]"

rake "build:all[$BUILD_CONFIG]"
